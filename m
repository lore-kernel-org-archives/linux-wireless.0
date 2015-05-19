Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57826 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920AbbESH2q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 03:28:46 -0400
Message-ID: <1432020524.7437.3.camel@sipsolutions.net> (sfid-20150519_092850_934967_DA77D2CE)
Subject: Re: [PATCH] Added 2 new Control Frames ( Beamforming Report Poll &
 VHT NDP Announcement) defined in 802.11ac
From: Johannes Berg <johannes@sipsolutions.net>
To: rahul.jain@samsung.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 19 May 2015 09:28:44 +0200
In-Reply-To: <2076339160.163631431579743152.JavaMail.weblogic@ep2mlwas05d> (sfid-20150514_070252_547798_4C831930)
References: <2076339160.163631431579743152.JavaMail.weblogic@ep2mlwas05d>
	 (sfid-20150514_070252_547798_4C831930)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-05-14 at 05:02 +0000, Rahul Jain wrote:
> hello All,
> 
> Below is the patch for 2 new control frames defined in 802.11ac.
> Please review and merge.
> 
> From b9ca335040547e565684f5bf60d37db896322663 Mon Sep 17 00:00:00 2001                                                                                                                                                                       
> From: rahul <rahul.jain@samsung.com>
> Date: Thu, 14 May 2015 10:21:48 +0530
> Subject: [PATCH] Added 2 new Control Frames ( Beamforming Report Poll & VHT 
>  NDP Announcement) defined in 802.11ac

As long as nobody is using these, I don't see much reason to merge this.

Also, a much better commit log would be needed.

johannes

