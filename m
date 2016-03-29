Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34442 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751588AbcC2Lqa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Mar 2016 07:46:30 -0400
Received: by mail-pa0-f54.google.com with SMTP id fe3so12004653pab.1
        for <linux-wireless@vger.kernel.org>; Tue, 29 Mar 2016 04:46:30 -0700 (PDT)
Subject: Re: Wireless Encryption
To: Aswin Paranji <aswin.paranji@gmail.com>,
	linux-wireless@vger.kernel.org
References: <CAAeNHhzywKhugKCPwLonXqTEnJJm7Td39JPof0xRxL+gOZ_xkg@mail.gmail.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <56FA6B07.9000807@broadcom.com> (sfid-20160329_134636_982756_0D2F78C3)
Date: Tue, 29 Mar 2016 13:46:15 +0200
MIME-Version: 1.0
In-Reply-To: <CAAeNHhzywKhugKCPwLonXqTEnJJm7Td39JPof0xRxL+gOZ_xkg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 29-3-2016 13:09, Aswin Paranji wrote:
> Hi,
> I'm trying to encrypt the 802.11 data with my own encryption instead
> of WEP or WPA. Can anybody guide me on how to do that and where I need
> to change. I'm trying to do this with Raspberry PI 3 device.

Umm. You mean you want to do it with the integrated wifi chipset on
RPi3. You can basically forget about that. Encryption is done on the
wifi device. The kernel passes 802.3 packets down to the device so there
is nothing to encrypt at that level and the device/firmware does not
have a way for you to plugin a different encryption.

Regards,
Arend

> Appreciate if you can guide me.
> 
> Regards,
> Aswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
