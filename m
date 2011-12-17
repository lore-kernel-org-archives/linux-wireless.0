Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33136 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab1LQQFx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Dec 2011 11:05:53 -0500
Received: by iaeh11 with SMTP id h11so6009810iae.19
        for <linux-wireless@vger.kernel.org>; Sat, 17 Dec 2011 08:05:52 -0800 (PST)
Message-ID: <4EECBDDC.5070908@lwfinger.net> (sfid-20111217_170613_239873_89128380)
Date: Sat, 17 Dec 2011 10:05:48 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Raffaele Recalcati <lamiaposta71@gmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: wl0084a / wl1271 understanding
References: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com>
In-Reply-To: <CAFU7RzPF7NKRkY70Vp_b55AUeDip+ePxk=zqJ_K=SsXUfse7Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/16/2011 10:54 PM, Raffaele Recalcati wrote:
> I'm an embedded developer and I really want opensource development for
> wireless, to be sure to maintain it in many kernel versions I will
> have.
> I'm not an wifi expert and so I can have done some mistakes here below.
>
> wl0084a
> =============
> grep -rin wl008 drivers
> give no result on kernel 3.2-rc6.
> What is the normal approach to take in account?
> I have to immediately change the usb wifi dongle due to the lacking of
> information to develop e proper driver or maybe
> there is some possibility?
> Here I can find Logilink drivers
> http://www.logilink.eu/content/support/download.htm?seticlanguage=en
> They confirm support for LINUX (kernel 2.6.18 ~ 2.6.33)
> Looking into drivers files ... yes , they are proprietary.

Some of the Logilink devices have Realtek chips. If this is a USB device, please 
post the output of 'lsusb'. If it is PCI, post the output of 'lspci -nnv' - we 
only need the part that describes the wireless device.

Larry

