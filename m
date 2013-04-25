Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2749 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757944Ab3DYVMd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Apr 2013 17:12:33 -0400
Message-ID: <51799C33.7040109@broadcom.com> (sfid-20130425_231237_626574_A63ADB41)
Date: Thu, 25 Apr 2013 14:12:19 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Bruno Randolf" <br1@einfach.org>
cc: "Arend van Spriel" <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, meuleman@broadcom.com,
	brudley@broadcom.com, brcm80211-dev-list@broadcom.com,
	"=?UTF-8?B?5rW36Je7?= =?UTF-8?B?5pWs5LmL?=" <tkaiso@thinktube.com>
Subject: Re: Broadcom brcmfmac vs bcmdhd on Android
References: <5176ABB1.2070506@einfach.org>
 <5176F8C2.7050502@broadcom.com> <5177F7D6.2020800@einfach.org>
 <51797866.9030403@einfach.org>
In-Reply-To: <51797866.9030403@einfach.org>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/25/2013 11:39 AM, Bruno Randolf wrote:
> I manually changed the list to only include 4330 and that way modinfo 
> shows it correctly also on the device, but maybe this is part of the 
> problem?
>
> How did you get it to work? Which device did you use (Galaxy Nexus?)?
> Do I need to activate CONFIG_BRCMFMAC_SDIO_OOB (I tried with no 
> difference)?
>
It looks like the device is not powered up. Do you see the wifi chip get 
enumerated by SDIO bus? There should be something like mmc0:0001:1 under 
/sys/bus/sdio/devices

Franky

