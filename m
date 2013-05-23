Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:36412 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759760Ab3EWW2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 18:28:17 -0400
Message-ID: <1369348092.17244.0.camel@jlt4.sipsolutions.net> (sfid-20130524_002819_909296_CB0A7921)
Subject: Re: [PATCH v2 1/2] iw: use updated structures and enums for packet
 pattern
From: Johannes Berg <johannes@sipsolutions.net>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 24 May 2013 00:28:12 +0200
In-Reply-To: <477F20668A386D41ADCC57781B1F70430E801DC656@SC-VEXCH1.marvell.com>
References: <1369344941-11217-1-git-send-email-bzhao@marvell.com>
	 <1369345157.12002.87.camel@jlt4.sipsolutions.net>
	 <477F20668A386D41ADCC57781B1F70430E801DC656@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 15:23 -0700, Bing Zhao wrote:
> Hi Johannes,
> 
> > On Thu, 2013-05-23 at 14:35 -0700, Bing Zhao wrote:
> > > From: Amitkumar Karwar <akarwar@marvell.com>
> > >
> > > They are renamed so that they can be used for new feature.
> > 
> > This isn't really necessary, right? I mean, it should compile w/o this
> > even after the kernel patches, but this is just for making it look
> > nicer?
> 
> Yes, it compiles w/o this patch. It does make it look nicer, I think.
> However, the commit message should be something like:
> 
> "They are renamed to match new nl80211.h and make the code look nicer."
> 
> Please let me know if you want me to resend 1/2 with revised commit log.
> Otherwise, please simply drop 1/2 and apply 2/2 alone.

No, no need. Just wanted to double-check. I started going through the
kernel side patches and had some comments, but I'm too tired to finish
now.

johannes

