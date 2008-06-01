Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:54745 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbYFAHw2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jun 2008 03:52:28 -0400
Received: by nf-out-0910.google.com with SMTP id d3so242635nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 01 Jun 2008 00:52:25 -0700 (PDT)
To: Andreas Gnau <Rondom@rondom.de>
Subject: Re: Is there any working 802.11N USB Nic?
Date: Sun, 1 Jun 2008 09:58:37 +0200
Cc: Ken Mandelberg <km@mathcs.emory.edu>,
	linux-wireless@vger.kernel.org
References: <48419F4C.3010201@mathcs.emory.edu> <4841B245.10502@Rondom.de>
In-Reply-To: <4841B245.10502@Rondom.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200806010958.37350.IvDoorn@gmail.com> (sfid-20080601_095232_270214_9AEE3D89)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 31 May 2008, Andreas Gnau wrote:
> Ken Mandelberg schrieb:
> > I have an Airlink AWLL6080 (Ralink 2870). Is there any native work for
> > this chipset? I've tried ndiswrapper with an XP driver, but that only
> > connects in G mode.
> 
> There are native drivers by Ralink for this chipset on their website.
> [1]. I don't know how well they work, though. Maybe the rt2x00-project
> will work on this once the current rt2x00 drivers are completely finished.

Work is already in progress to port the legacy drivers to rt2x00, but
due to lack of time this is going very slowely.

> NDISWrapper should also support 802.1n, so start a new thread in the
> NDISWrapper support forum [2], if you need additional help.
> 
> 
> [1] http://www.ralinktech.com/ralink/Home/Support/Linux.html
> [2]
> http://ndiswrapper.sourceforge.net/joomla/index.php?/component/option,com_fireboard/Itemid,34/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


