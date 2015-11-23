Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42785 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbbKWLbN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 06:31:13 -0500
Message-ID: <1448278260.5792.1.camel@sipsolutions.net> (sfid-20151123_123137_458261_60FB932C)
Subject: Re: wireless-testing repo
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 23 Nov 2015 12:31:00 +0100
In-Reply-To: <5652F62A.4000109@broadcom.com> (sfid-20151123_121912_784278_85DDFCC6)
References: <5652F62A.4000109@broadcom.com>
	 (sfid-20151123_121912_784278_85DDFCC6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-23 at 12:19 +0100, Arend van Spriel wrote:
> Hi John,
> 
> We have been using the wireless-testing repo in our nightly testing
> and as such appreciated the on-going support for it. I noticed your
> announcement (and misplaced it) and as I prefer to keep the nightly 
> testing will have to do the work over here. Can you provide details
> on what trees are merged into wireless-testing. Is it
> wireless-drivers{,-next} and mac80211{,-next} or is there more to 
> consider.

I believe it was also the latest rc from Linus.

If you're testing with backports you could also use the latest linux-
next with a restricted backport - I've added mac80211(-next) to that
now.

johannes


