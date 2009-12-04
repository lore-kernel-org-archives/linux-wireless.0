Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:56795 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbZLDIKE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Dec 2009 03:10:04 -0500
Received: by ewy19 with SMTP id 19so2481233ewy.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Dec 2009 00:10:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <43e72e890912031544j7cb8bffav1c1c7d016e740175@mail.gmail.com>
References: <43e72e890912031544j7cb8bffav1c1c7d016e740175@mail.gmail.com>
Date: Fri, 4 Dec 2009 09:10:10 +0100
Message-ID: <14b026160912040010k5dda243bra0abd9be4e275918@mail.gmail.com>
Subject: Re: Broadcom Android bcm4329 open driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5polish@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Greg KH <greg@kroah.com>,
	"Howard M. Harte" <hharte@broadcom.com>,
	bcm43xx-dev <bcm43xx-dev@lists.berlios.de>,
	Henry Ptasinski <henryp@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/12/4 Luis R. Rodriguez <mcgrof@gmail.com>:
> In case you haven't seen this yet, Broadcom has an open (!) driver on
> the Android git tree with support for SDIO/SPI for  bcm4329.
>
> http://tinyurl.com/broadcom-android-bcm4329
>
> The commit log entry dated 2009-10-29 states:
>
> Linux WLAN driver for BCM4329 - Low-Power 802.11n with Bluetooth(R)
> 2.1+ EDR and FM (Tx and Rx)

This driver was already noticed in January:
http://lists.berlios.de/pipermail/bcm43xx-dev/2009-January/thread.html#5066
See Thomas's response for details about driver:
http://lists.berlios.de/pipermail/bcm43xx-dev/2009-January/005072.html

So that device controlled by SDIO has it's own CPU which cares of
wireless. As you noticed there is also SPI but is this used anywhere
except Android devices? Driver seems to check PCI buses just to find
SPI.

-- 
Rafał
