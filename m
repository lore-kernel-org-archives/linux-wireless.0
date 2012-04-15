Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout4.freenet.de ([195.4.92.94]:48068 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750946Ab2DOGn0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 02:43:26 -0400
Received: from [195.4.92.142] (helo=mjail2.freenet.de)
	by mout4.freenet.de with esmtpa (ID andihartmann@freenet.de) (port 25) (Exim 4.76 #1)
	id 1SJJBF-0006A4-5q
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:43:25 +0200
Received: from localhost ([::1]:48230 helo=mjail2.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJJBF-0007ak-1y
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:43:25 +0200
Received: from [195.4.92.12] (port=54721 helo=2.mx.freenet.de)
	by mjail2.freenet.de with esmtpa (ID andihartmann@freenet.de) (Exim 4.76 #1)
	id 1SJJ9E-00078o-Ms
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:41:20 +0200
Received: from [2002:4fde:769:2:5054:ff:feb8:40bd] (port=38203 helo=mail.maya.org)
	by 2.mx.freenet.de with esmtpsa (ID andihartmann@freenet.de) (TLSv1:AES256-SHA:256) (port 25) (Exim 4.76 #1)
	id 1SJJ9E-0005gO-Em
	for linux-wireless@vger.kernel.org; Sun, 15 Apr 2012 08:41:20 +0200
Message-ID: <4F8A6D88.30201@01019freenet.de> (sfid-20120415_084329_214383_610C8A74)
Date: Sun, 15 Apr 2012 08:41:12 +0200
From: Andreas Hartmann <andihartmann@01019freenet.de>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	IvDoorn@gmail.com, linville@tuxdriver.com, gwingerde@gmail.com,
	helmut.schaa@googlemail.com
Subject: Re: [rt2x00-users] [PATCH] wireless: rt2x00: rt2800pci add more RT539x
 ids
References: <1334439201-13424-1-git-send-email-xose.vazquez@gmail.com>
In-Reply-To: <1334439201-13424-1-git-send-email-xose.vazquez@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:
> RT539x devices:
> (0x1814, 0x5362)
> (0x1814, 0x5392)
> 
> Taken from ralink driver 2011_0406_RT5390_RT5392_Linux_STA_V2.5.0.3_DPO

Did you test them? How did you test them? What exactly is working? What not?


Regards,
Andreas
