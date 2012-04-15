Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:42598 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2DOGk5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 02:40:57 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SJJ8o-0000Ie-SQ
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:40:54 +0200
Received: from localhost ([::1]:34314 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJJ8o-0000Ba-QP
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:40:54 +0200
Received: from [195.4.92.11] (port=49248 helo=1.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJJ5y-000833-T5
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:37:58 +0200
Received: from [2002:4fde:769:2:5054:ff:feb8:40bd] (port=51075 helo=mail.maya.org)
	by 1.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SJJ5y-0002KR-I6
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:37:58 +0200
Message-ID: <4F8A6CB6.4080006@01019freenet.de> (sfid-20120415_084134_736662_05018278)
Date: Sun, 15 Apr 2012 08:37:42 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800usb add more devices
 ids
References: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:
> They were taken from ralink drivers:
> 2011_0719_RT3070_RT3370_RT5370_RT5372_Linux_STA_V2.5.0.3_DPO
> 2012_03_22_RT5572_Linux_STA_v2.6.0.0_DPO
> 
> 0x1eda,0x2210 RT3070 Airties
> 
> 0x083a,0xb511 RT3370 Panasonic
> 0x0471,0x20dd RT3370 Philips
> 
> 0x1875,0x7733 RT3573 Air Live
> 0x7392,0x7733 RT3573 Edimax
> 0x0e66,0x0021 RT3573 Hawking
> 0x2019,0xed19 RT3573 Planex
> 0x148f,0x3573 RT3573 Ralink
> 0x0df6,0x0067 RT3573 Sitecom
> 0x1690,0x0764 RT35xx Askey
> 0x0df6,0x0065 RT35xx Sitecom
> 0x0df6,0x0066 RT35xx Sitecom
> 0x0df6,0x0068 RT35xx Sitecom
> 
> 0x2001,0x3c1c RT5370 DLink
> 0x2001,0x3c1d RT5370 DLink
> 
> 2001 is D-Link not Alpha

Did you test them? What did you test exactly? What exactly works, what
does not?

It doesn't mean anything, if they work with the legacy driver. Linksys
WUSB600Nv2 e.g. works fine with the legacy driver, but only limited (if
at all) with rt2800usb yet.


Regards,
Andreas
