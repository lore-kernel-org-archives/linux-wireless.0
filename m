Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:63280 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804AbZB0TPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 14:15:23 -0500
Received: by ewy25 with SMTP id 25so1456083ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 11:15:20 -0800 (PST)
Message-ID: <49A83BC5.2020204@gmail.com> (sfid-20090227_201526_848928_E3C4560E)
Date: Fri, 27 Feb 2009 20:15:17 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Fwd: b43* linux driver, more ids dev
References: <ee588a540902270946h13e03b6el71de5237a458b7a3@mail.gmail.com> <ee588a540902270955j214d98d2uf58858d12a7787cc@mail.gmail.com> <49A83765.30202@lwfinger.net>
In-Reply-To: <49A83765.30202@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:

> Xose Vazquez Perez wrote:
> 
>> are there any trouble with these devices ? why are they not  inside
>> b43* drivers ?
>>
>> PCI_VENDOR_ID_BROADCOM, 0x4313
>> PCI_VENDOR_ID_BROADCOM, 0x4315
>> PCI_VENDOR_ID_BROADCOM, 0x432a
>> PCI_VENDOR_ID_BROADCOM, 0x432b
>> PCI_VENDOR_ID_BROADCOM, 0x432c
>> PCI_VENDOR_ID_BROADCOM, 0x432d
> 
> Those devices are either LP PHY (4315 and probably 4313) or N PHY (432X)
> devices. The reverse engineering for the LP PHY was just completed, but the code
> is not yet written. The RE for the N PHY has barely begun.
> 
> Once there is code to drive those devices, their ID's will be added.

It smells like another crap_driver for staging tree.

-- 
Polycommander, Erkowit, Urquiola, Andros Patria, Cason, Aegean Sea, Prestige, ...
