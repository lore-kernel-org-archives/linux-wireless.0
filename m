Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50191 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab2LLWLa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 17:11:30 -0500
Message-ID: <1355350313.9708.22.camel@jlt4.sipsolutions.net> (sfid-20121212_231134_220059_715AD233)
Subject: Re: Question about "authorized state" test in tx.c
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 12 Dec 2012 23:11:53 +0100
In-Reply-To: <CAMcMvsid-g4LticD+LcpvP4jaEQrsYy09gjcqtt0=_PMxFuxtQ@mail.gmail.com> (sfid-20121212_230914_909322_61393D7E)
References: <CAMcMvshyr6p2dqv-4YKW3=ZqLXskqvOtR9E4+UGOM4pzzJumgg@mail.gmail.com>
	 <1355346934.9708.17.camel@jlt4.sipsolutions.net>
	 <CAMcMvsid-g4LticD+LcpvP4jaEQrsYy09gjcqtt0=_PMxFuxtQ@mail.gmail.com>
	 (sfid-20121212_230914_909322_61393D7E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-12-12 at 14:09 -0800, Paul Stewart wrote:

> > That commit was meant for AP mode, and in managed mode hdr.addr1 should
> > never be a multicast address. Any idea how that happens?
> 
> Good point.  I mistook that for the Ethernet addr1.  Moreover, looking
> at the packet capture, this is a "from DS to STA" frame, which implies
> I compeltely mistook where this frame originated from (either that or
> something much stranger is happening).  

That seems like it's just an (unrelated) broadcast frame from somebody
else, I'd imagine if it was yours the AP wouldn't first retransmit it
and then deauth you.

johannes

