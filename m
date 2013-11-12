Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1523 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751427Ab3KLRvK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Nov 2013 12:51:10 -0500
Message-ID: <52826A82.3010505@broadcom.com> (sfid-20131112_185114_493588_F225A4FE)
Date: Tue, 12 Nov 2013 18:50:58 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Alessandro Gnagni" <enterprise.nx@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: Trying to add support of 802.11ac broadcom chpiset to
 openwrt
References: <52821B80.6000305@gmail.com>
In-Reply-To: <52821B80.6000305@gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/12/2013 01:13 PM, Alessandro Gnagni wrote:
> Hi,
> i am trying to implement on a smart city network a solution based on
> high end home routers like the asus RT-AC66U.
> we want to use openwrt for that but unfortunately the broadcom driver
> isn't yet supported.
> I have one rt-ac66u here for development, there is anything that i can
> do for help?
> i came here after a suggestion of one member on openwrt forum:
> https://forum.openwrt.org/viewtopic.php?pid=217341#p217341
>
> i also read this past email:
> http://www.spinics.net/lists/linux-wireless/msg110443.html

Not sure what 11ac chipset is used. The upstream brcm80211 drivers 
currently only support one 11ac chipset, ie. the bcm4335. This is a 
single stream with SDIO host interface supported by the fullmac driver 
brcmfmac.

For chipsets like 4360 we need to add AC phy support to brcmsmac. So far 
we do not have green light to do so.

Regards,
Arend

> Thx for attention.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


