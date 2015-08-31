Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36061 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753422AbbHaRGT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 13:06:19 -0400
Received: by wibz8 with SMTP id z8so6677747wib.1
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 10:06:18 -0700 (PDT)
Subject: Re: RTL8189ETV
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Hans de Goede <hdegoede@redhat.com>
References: <55E47A27.4090703@gmail.com>
From: poma <pomidorabelisima@gmail.com>
Message-ID: <55E48988.1000803@gmail.com> (sfid-20150831_190622_932183_F447251A)
Date: Mon, 31 Aug 2015 19:06:16 +0200
MIME-Version: 1.0
In-Reply-To: <55E47A27.4090703@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 31.08.2015 18:00, poma wrote:
> 
> Hi Fi,
> 
> What is this device, is it supported by
> https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8189es
> 
> $ modinfo rtl8189es
> modinfo: ERROR: Module rtl8189es not found.
> 

or is it supported by
https://github.com/orangepi-xunlong/linux-sunxi/tree/orangepi-3.4/drivers/net/wireless/rtl8188eu
https://github.com/lwfinger/rtl8188eu
as RTL8188ETV is

$ modinfo rtl8188eu
modinfo: ERROR: Module rtl8188eu not found.


However RTL8188ETV is USB 2.0 device,
eeeeeeeeeeeeeeeeeee not again!




