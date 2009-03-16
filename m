Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f165.google.com ([209.85.217.165]:35123 "EHLO
	mail-gx0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCPQS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 12:18:27 -0400
Received: by gxk9 with SMTP id 9so1943521gxk.13
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 09:18:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090316155152.276920@gmx.net>
References: <ee588a540903160324s59c83547jc7d2148642e00af4@mail.gmail.com>
	 <20090316155152.276920@gmx.net>
Date: Mon, 16 Mar 2009 09:18:24 -0700
Message-ID: <43e72e890903160918p75c8ee5cja0ff4a308d24c407@mail.gmail.com> (sfid-20090316_171829_816951_C60CE9EF)
Subject: Re: well working usb wlan stick
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	feldmann_markus@gmx.de, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 8:51 AM, Alina Friedrichsen <x-alina@gmx.net> w=
rote:
> Hi!
>
>> only buy ZyDAS/Atheros(zd1211rw driver), =C2=A0Realtek(rtl8187 drive=
r) or
>> Ralink(rt73usb driver) devices.
>
> As far I have tested, the ar9170 driver works okay for G too, only Dr=
aft-N is not supported at the moment.

11n does work but currently only in the the otus driver, which is also
open but it just doesn't use mac80211. ar9170 is the driver which will
eventually get merged.

http://wireless.kernel.org/en/users/Drivers/ar9170
http://wireless.kernel.org/en/users/Drivers/otus

  Luis
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
