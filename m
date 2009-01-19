Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.156]:16715 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZASTHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 14:07:48 -0500
Received: by fg-out-1718.google.com with SMTP id 19so1374856fgg.17
        for <linux-wireless@vger.kernel.org>; Mon, 19 Jan 2009 11:07:46 -0800 (PST)
Message-ID: <3ace41890901191107g4100bb36j830ab31ab0202d13@mail.gmail.com> (sfid-20090119_200755_508248_98463FEF)
Date: Mon, 19 Jan 2009 19:07:46 +0000
From: "Hin-Tak Leung" <hintak.leung@gmail.com>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Subject: Re: USB 1.1, usb-dongle, NETGEAR WG111v2, timing problems in association
Cc: "Hans Ekbrand" <hans@sociologi.cjb.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <4972B25B.7070306@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20090117204654.GB9079@amin> <4972B25B.7070306@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 18, 2009 at 4:38 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> Hans Ekbrand wrote:
>> Hi list!
>>
>> On an old system with only USB 1.1, I tried to use a USB-dongle:
>> NETGEAR WG111v2. The device works perfectly with same kernel (2.6.26-1
>> from debian lenny) on a new system with USB 2.0, using the "rtl8187"
>> driver.
>>
>> However, on USB 1.1 I get:
>
> I just bought a WG111v2 on E-Bay last week. Once it arrives, I will be
> able to test the performance of this device.
>
> Larry
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Can you shut  down NetworkManager and wpa_supplicant and try
association with iwconfig manually?
Sounds like wpa_supplicant mis-config for me, so you might want to
review your config.
