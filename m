Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42310 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757689Ab2IDTq7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Sep 2012 15:46:59 -0400
Message-ID: <1346788056.3737.44.camel@jlt4.sipsolutions.net> (sfid-20120904_214702_220903_DE083ADC)
Subject: Re: [RFC] cfg/nl/mac80211: use per-band basic rates bitmap in IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <ordex@autistici.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 04 Sep 2012 21:47:36 +0200
In-Reply-To: <20120904194532.GJ22841@ritirata.org>
References: <1346784741-7003-1-git-send-email-ordex@autistici.org>
	 <1346787524.3737.43.camel@jlt4.sipsolutions.net>
	 <20120904194532.GJ22841@ritirata.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-09-04 at 21:45 +0200, Antonio Quartulli wrote:

> > As far as I understand it, the basic rates that are passed into the
> > kernel are intended to be used when the kernel creates a new IBSS. This
> > always happens on the channel that is also passed in, so it's always
> > bound to a given channel (band).
> 
> I think basic rates are also used in case of merging, right? In this case we
> could switch to another channel (and band).

No, as I understand it we should in that case use the IBSS's existing
basic rates, not our own.

johannes

