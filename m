Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59828 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754134AbbAFOOx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2015 09:14:53 -0500
Message-ID: <1420553688.1966.33.camel@sipsolutions.net> (sfid-20150106_151456_818919_DD458323)
Subject: Re: [PATCH 1/3] mac80211: consider only relevant vifs for
 radar_required calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 06 Jan 2015 15:14:48 +0100
In-Reply-To: <1420553111.1966.32.camel@sipsolutions.net> (sfid-20150106_150519_011633_F895ABF1)
References: <1420366399-31535-1-git-send-email-eliad@wizery.com>
	 (sfid-20150104_111329_158953_6FBC20BD) <1420542274.1966.21.camel@sipsolutions.net>
	 (sfid-20150106_120447_628454_273C3B51) <1420553111.1966.32.camel@sipsolutions.net>
	 (sfid-20150106_150519_011633_F895ABF1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-01-06 at 15:05 +0100, Johannes Berg wrote:
> On Tue, 2015-01-06 at 12:04 +0100, Johannes Berg wrote:
> > all three applied.
> 
> Nope, dropped patch 2 again

And dropped the other two also - with them the sequence of two tests I
was looking at never completes.

johannes

