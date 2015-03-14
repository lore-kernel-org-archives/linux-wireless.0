Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:35437 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbbCNWNz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Mar 2015 18:13:55 -0400
Received: by webcq43 with SMTP id cq43so14091045web.2
        for <linux-wireless@vger.kernel.org>; Sat, 14 Mar 2015 15:13:54 -0700 (PDT)
Message-ID: <5504B29F.8000305@gmail.com> (sfid-20150314_231400_662091_C0950D39)
Date: Sat, 14 Mar 2015 23:13:51 +0100
From: Ochal Christophe <christophe.ochal@gmail.com>
MIME-Version: 1.0
To: Stefan Lippers-Hollmann <s.l-h@gmx.de>
CC: Arend van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Broadcom 43340
References: <550482A2.3080803@gmail.com>	<55048833.90408@broadcom.com>	<55048BB1.9080906@gmail.com>	<550491DA.6030105@broadcom.com>	<55049507.6040209@gmail.com> <20150314213907.3f1167bb@mir>
In-Reply-To: <20150314213907.3f1167bb@mir>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All,

On 03/14/2015 09:39 PM, Stefan Lippers-Hollmann wrote:
> You don't need to run windows for that, the nvram (calibration data, 
> probably the MAC address and related device specific data) is stored 
> in your mainboard's firmware - and exposed to userspace (under linux) 
> via /sys/firmware/efi/efivars/. You just need to identify the correct 
> file and copy it to a place where linux expects to find it 
> (/lib/firmware/brcm/brcmfmac43340-sdio.txt). Regards Stefan 
> Lippers-Hollmann 

Thanks for the hint, that did it, I'm online!

With Kind Regards,
Christophe Ochal
