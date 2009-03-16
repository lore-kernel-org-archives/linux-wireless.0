Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.29]:23510 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbZCPQjN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Mar 2009 12:39:13 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1097306yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Mar 2009 09:39:10 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090316163731.206110@gmx.net>
References: <ee588a540903160324s59c83547jc7d2148642e00af4@mail.gmail.com>
	 <20090316155152.276920@gmx.net>
	 <43e72e890903160918p75c8ee5cja0ff4a308d24c407@mail.gmail.com>
	 <20090316163731.206110@gmx.net>
Date: Mon, 16 Mar 2009 09:39:09 -0700
Message-ID: <43e72e890903160939x4603d814s853c7caca1ae09c7@mail.gmail.com> (sfid-20090316_173915_845607_6F012F45)
Subject: Re: well working usb wlan stick
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Alina Friedrichsen <x-alina@gmx.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 16, 2009 at 9:37 AM, Alina Friedrichsen <x-alina@gmx.net> wrote:
> Hi Luis!
>
>> 11n does work but currently only in the the otus driver, which is also
>> open but it just doesn't use mac80211. ar9170 is the driver which will
>> eventually get merged.
>
> Yes, but the otus driver is currently less stable then the ar9170 driver. After my patches I haven't discovered a kernel panic anymore with it.
>
> [STA, IBSS, not AP - max. ca. 2,4 MByte/s]

Oh I wouldn't doubt it :)

  Luis
