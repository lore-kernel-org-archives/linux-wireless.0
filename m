Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49042 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab3KNP32 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:29:28 -0500
Message-ID: <1384442962.13941.36.camel@jlt4.sipsolutions.net> (sfid-20131114_162932_449039_39147D29)
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: janusz.dziedzic@tieto.com, j@w1.fi, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com, linux-wireless@vger.kernel.org
Date: Thu, 14 Nov 2013 16:29:22 +0100
In-Reply-To: <20131114153339.GB30653@garbanzo.do-not-panic.com> (sfid-20131114_162303_512952_BEB5909B)
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
	 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
	 <1384378096.28806.20.camel@jlt4.sipsolutions.net>
	 <20131114143126.GC19070@garbanzo.do-not-panic.com>
	 <1384440519.13941.31.camel@jlt4.sipsolutions.net>
	 <20131114153339.GB30653@garbanzo.do-not-panic.com>
	 (sfid-20131114_162303_512952_BEB5909B)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-11-14 at 07:33 -0800, Luis R. Rodriguez wrote:
> > Still doesn't make sense - HANDLE_DFS means "I'll react to radar
> > detection events and will do the CSA". It has absolutely nothing to do
> > with DFS regions. Please keep those things separate.
> 
> How you deal with radar detection is completely dependent on the DFS
> region, no?

You're missing *my* point :-)

Radar *detection* is region-dependent.

What happens *after* that (announce a channel switch, etc.) isn't at
all.

johannes

