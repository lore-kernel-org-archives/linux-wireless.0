Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f179.google.com ([209.85.214.179]:34178 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003AbbEPOeX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 May 2015 10:34:23 -0400
Received: by obfe9 with SMTP id e9so96675153obf.1
        for <linux-wireless@vger.kernel.org>; Sat, 16 May 2015 07:34:22 -0700 (PDT)
Message-ID: <5557556C.2080107@lwfinger.net> (sfid-20150516_163443_494312_185B609B)
Date: Sat, 16 May 2015 09:34:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Schmirr Wurst <schmirrwurst@gmail.com>, b43-dev@lists.infradead.org
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: lspci not working
References: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
In-Reply-To: <CA+0W_As0c=eAijuvWfSBLMY4vj2P1-zoMsjz1mmNm0_vfepPCA@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/16/2015 04:12 AM, Schmirr Wurst wrote:
> I've already posted the message once, but as it was my first, I'm not
> sure, if it worked...
>
> Actually I'm trying to get read of a t100af from asus, that has a nice
> broadcom wifi chipset, but I'm wondering that I don't see anything
> with lspci, do that mean, that the chipset is broken ?
> (I though lspci is one level deeper than driver, and I should see
> something, even if I have driver problems) ?
>
> Could just somebody tell me if I'm right or wrong ?

On Intel Bay Trail tablets, the wifi device is frequently attached using an SDIO 
bus, not a PCI connection. Accordingly, lspci will probably not show the device.

I am not familiar with any Broadcom devices that use SDIO, but I have Cc'd the 
linux-wireless mailing list. Perhaps someone there will be able to help.

I am currently working with a Winbook TW100, which is another Bay Trail device. 
It uses a Realtek RTL8723BS, which also has an SDIO interface.

Larry

