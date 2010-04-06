Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f223.google.com ([209.85.220.223]:43257 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab0DFWf6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Apr 2010 18:35:58 -0400
Received: by fxm23 with SMTP id 23so434722fxm.21
        for <linux-wireless@vger.kernel.org>; Tue, 06 Apr 2010 15:35:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BB8CEAE.6040101@gmail.com>
References: <4BB25383.8040405@gmail.com> <880c1631003301242r5492a2f8ucd4b83f7d607bf89@mail.gmail.com>
	<y2k880c1631004030510t132c763bgc9af3061ffabdfeb@mail.gmail.com>
	<4BB8CEAE.6040101@gmail.com>
From: Luis Correia <luis.f.correia@gmail.com>
Date: Tue, 6 Apr 2010 23:08:12 +0100
Message-ID: <v2lefe7343f1004061508o668f4ce2s7592af27904346c1@mail.gmail.com>
Subject: Re: [rt2x00-users] FW RT307x/RT309x
To: Richard Farina <sidhayn@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi and sorry about the delay,

On Sun, Apr 4, 2010 at 18:38, Richard Farina <sidhayn@gmail.com> wrote:
> Luis Correia wrote:
>>
>> Hi all,
>>
>> here is an update, Ralink has released new firmware files, no need to
>> go on 'ripping stuff out of code'.
>>
>> ---
>> Firmware RT28XX/RT30XX PCI/mPCI/PCIe/CardBus series
>>
>> (RT2760/RT2790/RT2860/RT2890/RT3060/RT3062/RT3562/RT2860/RT2760/RT2890/RT2790/RT3090)
>>
>>
>> http://www.ralinktech.com/license_us.php?n=2&p=1&t=U0wyRnpjMlYwY3k4eU1ERXdMekF6THpNeEwyUnZkMjVzYjJGa01UWTBNamsyTVRBNE1pNTZhWEE5UFQxU1ZESTROakJmUm1seWJYZGhjbVZmVmpJMkM%3D
>> ---
>> Firmware RT28XX/RT30XX USB series
>> (RT2870/RT2770/RT3572/RT3070)
>>
>>
>> http://www.ralinktech.com/license_us.php?n=2&p=1&t=U0wyRnpjMlYwY3k4eU1ERXdMekF6THpNeEwyUnZkMjVzYjJGa01UWXpPRGs1T0Rnek5pNTZhWEE5UFQxU1ZESTROekJmUm1seWJYZGhjbVZmVmpJeUM%3D
>> ---
>>
>>
>
> Great, are these newer versions of the ones in linux-firmware.git? Can we
> get linux-firmware.git updated?

To be completely honest, I have no idea of what's in linux-firmware.git .

We, the rt2x00 project, do not distribute firmware files with the
driver, it's up to the various distributions to deal with this.

> Thanks,
> Rick Farina

Luis Correia
rt2x00 project admin
