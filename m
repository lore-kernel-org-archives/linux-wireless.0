Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:36883 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab0IWKC0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 06:02:26 -0400
Received: by gxk9 with SMTP id 9so478529gxk.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Sep 2010 03:02:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTin7eTsGXBb5VXsRU_4rwvFpU3-BYe+2w5352SRE@mail.gmail.com>
References: <SNT113-W3652C8510E7AB89D2036ECF17E0@phx.gbl>
	<AANLkTin7eTsGXBb5VXsRU_4rwvFpU3-BYe+2w5352SRE@mail.gmail.com>
Date: Thu, 23 Sep 2010 12:02:25 +0200
Message-ID: <AANLkTimfvN5s4qPNvRvHHZo8fZ_y1ti=ukdTRybLd7=A@mail.gmail.com>
Subject: Re: Compiling carl9170
From: Christophe Chapuis <chris.chapuis@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just for information, I managed to retrieve and compile
compat-wireless from sept. 20th. I fixed manually the little typo in
wmi.c, and then everything went well. I selected the driver "ath",
resulting in all the "ath" drivers to be compiled, including carl9170.

I'm now using this driver, with his firmware, with great success. It
uses 802.11n, seems quite stable, keeps my wifi connection alive.

Bravo !


On Mon, Sep 20, 2010 at 9:15 AM, Christophe Chapuis
<chris.chapuis@gmail.com> wrote:
> Actually, the carl9170 driver has been included in compat-wireless,
> but the compilation of compat-wireless fails since then (latest
> successful baking was sept. 12th). I hope this will be fixed soon.
> Having the same adapter as you, I'm also following the situation daily :)
>
> On Mon, Sep 20, 2010 at 4:32 AM, Dale Turner <rx_guy@hotmail.com> wrote:
>>
>> Hello.
>>
>> Can someone tell me how to compile the carl9170 module
>> WITHOUT compiling a complete kernel. I just purchased a TP-Link WN821N
>> based on the capabilities of this driver, but am disappointed that I
>> currently don't have the module.
>>
>> I am familiar with the
>> compat-wireless packages as I have needed to compile the ath9k_htc
>> driver for my other adapter (TP-Link WN721N), but the carl driver does
>> not seem to be available in that package.
>>
>> Can anyone help??
>>
>> Thanks in advance.
>>
>> (Sorry about the first post without a subject)
>>
>> Dale Turner
>>                                          --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
