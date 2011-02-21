Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33273 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783Ab1BUQGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Feb 2011 11:06:21 -0500
Received: by wwa36 with SMTP id 36so6228181wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Feb 2011 08:06:20 -0800 (PST)
Message-ID: <4D628D75.1070907@lwfinger.net>
Date: Mon, 21 Feb 2011 10:06:13 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Mathieu Malaterre <mathieu.malaterre@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: Realtek RTL8192SE support ? (aka r8192se_pci)
References: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com>
In-Reply-To: <AANLkTinoU0Dxy2iAHEsprTbakrbs8a8vPARFW0odz4g9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/21/2011 03:35 AM, Mathieu Malaterre wrote:
> Dear all,
>
>    As far as I know driver for rtl8192su will be added to kernel
> 2.6.38. By any chance does anyone knows if rtl8192se will make it into
> this release ?

As part of our collaborative effort, Realtek has sent me a mac80211-based driver 
for the RTL8192SE. It will be submitted to the wireless mailing list for review 
once the driver for the RTL8192CU is accepted. The earliest this would happen is 
2.6.39, but I think 2.6.40 is more realistic. I also have a driver for the 
RTL8192DE that will follow the RTL8192SE.

The driver for the RTRL8192SU does not use mac80211 and is in 2.6.37. It is 
known as r8712u.

Larry
