Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:35611 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757143AbZB0S4k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 13:56:40 -0500
Message-ID: <49A83765.30202@lwfinger.net> (sfid-20090227_195648_685087_60E1CF16)
Date: Fri, 27 Feb 2009 12:56:37 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Fwd: b43* linux driver, more ids dev
References: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com> <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com>
In-Reply-To: <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Xose Vazquez Perez wrote:

> are there any trouble with these devices ? why are they not  inside
> b43* drivers ?
> 
> PCI_VENDOR_ID_BROADCOM, 0x4313
> PCI_VENDOR_ID_BROADCOM, 0x4315
> PCI_VENDOR_ID_BROADCOM, 0x432a
> PCI_VENDOR_ID_BROADCOM, 0x432b
> PCI_VENDOR_ID_BROADCOM, 0x432c
> PCI_VENDOR_ID_BROADCOM, 0x432d

Those devices are either LP PHY (4315 and probably 4313) or N PHY (432X)
devices. The reverse engineering for the LP PHY was just completed, but the code
is not yet written. The RE for the N PHY has barely begun.

Once there is code to drive those devices, their ID's will be added.

Larry
