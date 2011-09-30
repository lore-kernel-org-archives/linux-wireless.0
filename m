Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51868 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978Ab1I3PSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Sep 2011 11:18:05 -0400
Received: by gyg10 with SMTP id 10so1573393gyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 30 Sep 2011 08:18:04 -0700 (PDT)
Message-ID: <4E85DDA9.3090300@lwfinger.net> (sfid-20110930_171810_079336_A4F5D9A2)
Date: Fri, 30 Sep 2011 10:18:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: v4mp <gaigo88@hotmail.it>
CC: linux-wireless@vger.kernel.org,
	'George0505' <george0505@realtek.com>,
	'georgia' <georgia@realtek.com>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org>
In-Reply-To: <loom.20110930T160704-310@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/30/2011 09:20 AM, v4mp wrote:
> hello larry,
>
> i've an ALFA AWUS036NHR and i tried latest compat-wireless-2011-09-27 on ubuntu
> natty 3.0.4-030004-generic,
> the adapter is recognized as rtl8192cu but is not
> responding, no network is detected.
>
> Then if i try to "modprobe -r rtl8192cu" results
> FATAL: Error removing rtl8192cu
> (/lib/modules/3.0.4-030004-generic/updates/drivers/net/wireless/rtlwifi
> /rtl8192cu/rtl8192cu.ko):
> Device or resource busy
>
> seems that remains blocked..i can't do anything

You are the second person that has reported a problem with this device. 
Unfortunately, I do not have a sample of the device, but I have just ordered one 
that will be delivered in about one week. I would guess that there is some 
difference between the RTL8192CU and the RTL8188RU chips.

I Cc'd the Realtek group that works on USB devices. Perhaps they have some info 
that will be useful. Given the difference in time between the US and Taiwan, I 
would not expect any answer until Monday.

There are some changes that affect connection with an 802.11n network that are 
found in the latest kernels. I'm not sure they are in the one you are using. You 
can get the very latest by downloading and building the "bleeding edge" version 
of compat-wireless.

Larry
