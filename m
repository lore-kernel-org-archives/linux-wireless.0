Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout2.freenet.de ([195.4.92.92]:38904 "EHLO mout2.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752626Ab2DOSLo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 14:11:44 -0400
Received: from [195.4.92.140] (helo=mjail0.freenet.de)
	by mout2.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SJTvK-0000pg-K8
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 20:11:42 +0200
Received: from localhost ([::1]:33906 helo=mjail0.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJTvK-000581-Dm
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 20:11:42 +0200
Received: from [195.4.92.19] (port=41339 helo=9.mx.freenet.de)
	by mjail0.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJTtH-0003aa-AD
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 20:09:35 +0200
Received: from [2002:4fde:7ca:2:5054:ff:feb8:40bd] (port=34716 helo=mail.maya.org)
	by 9.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SJTtH-0003Cv-0q
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 20:09:35 +0200
Message-ID: <4F8B0ED1.5050302@01019freenet.de> (sfid-20120415_201148_052897_0ED30796)
Date: Sun, 15 Apr 2012 20:09:21 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Gertjan van Wingerde <gwingerde@gmail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>,
	"IvDoorn@gmail.com" <IvDoorn@gmail.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"helmut.schaa@googlemail.com" <helmut.schaa@googlemail.com>
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800usb add more devices
 ids
References: <1334448592-16391-1-git-send-email-xose.vazquez@gmail.com> <4F8A6CB6.4080006@01019freenet.de> <4F8A92A5.8090707@gmail.com> <4F8AB8F9.4060503@01019freenet.de> <201C9B63-C214-4D44-B3D0-44948F9DE260@gmail.com>
In-Reply-To: <201C9B63-C214-4D44-B3D0-44948F9DE260@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Gertjan,

thank you for your response!


Gertjan van Wingerde wrote:
[...]
> It is impossible to test each and every device that uses a Ralink
> chipset. Therefore we run tests on the chipsets only, and simply list
> all devices that contain these chipsets.
> 
> Granted, we are having issues with some of the chipsets, but that
> should not prevent adding other devices that use the same chipset to
> the driver.

It would help for making decisions on which brand to buy, if there were
a notice in the source code, e.g.: _device successfully tested
(802.11abgn)_ - other devices don't get any comment.

This way, I would be completely content with the practice to fire in
blindly every ID of each existing device containing a Ralink chipset.


Kind regards,
Andreas
