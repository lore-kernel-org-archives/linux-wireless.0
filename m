Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:57337 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751112Ab2FGTwz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 15:52:55 -0400
Message-ID: <1339098774.14838.4.camel@joe2Laptop> (sfid-20120607_215258_792628_898162C5)
Subject: Re: [PATCH] mac80211: ratelimit few aggregated messages
From: Joe Perches <joe@perches.com>
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Date: Thu, 07 Jun 2012 12:52:54 -0700
In-Reply-To: <4FD0688F.5020603@qca.qualcomm.com>
References: <1339048943-4643-1-git-send-email-mohammed@qca.qualcomm.com>
	 <1339050308.6009.9.camel@joe2Laptop> <4FD0540C.5060808@qca.qualcomm.com>
	 <1339053852.6009.13.camel@joe2Laptop> <4FD05A27.80102@qca.qualcomm.com>
	 <1339055836.6009.20.camel@joe2Laptop> <4FD0688F.5020603@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-06-07 at 14:08 +0530, Mohammed Shafi Shajakhan wrote:
> On Thursday 07 June 2012 01:27 PM, Joe Perches wrote:
> > On Thu, 2012-06-07 at 13:07 +0530, Mohammed Shafi Shajakhan wrote:
> >> what about the other wiphy_debug messages, we would
> >> still retain them know
> >
> > Yes, and...
> >
> > No, you know those should now still be wiphy_debug
> > unless the message is HT related and need a new change.
> 
> sure. so lets drop this patch and do that generic stuff.

I did a little while ago.
Please modify the patch based on wireless-next commit d63e9ae3b12

cheers, Joe

