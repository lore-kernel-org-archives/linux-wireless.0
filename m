Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:32820 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264AbbIHHuc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 03:50:32 -0400
Received: by lamp12 with SMTP id p12so62032869lam.0
        for <linux-wireless@vger.kernel.org>; Tue, 08 Sep 2015 00:50:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55EDFB26.8000708@broadcom.com>
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>
	<55DAD0FD.3070807@broadcom.com>
	<CANfLQrYQnk6bUjPEKxucxBhLvsRsqpfydvAkvsvKdg0nnte3iA@mail.gmail.com>
	<CAG8K7gRdXqpfA3_HPoaM+ivgxH4eiPRWkD238QwMMbNigYHDBw@mail.gmail.com>
	<CANfLQraZAkw0Eqt-Mog5t4ZfGFx3xm_8-6nJoJ68Mim18bW3Tg@mail.gmail.com>
	<CANfLQrYVq_eMa-CLJhqVthbm_h7yLBhZN5nm0_f70eEob+rUdw@mail.gmail.com>
	<55EDFB26.8000708@broadcom.com>
Date: Tue, 8 Sep 2015 10:50:31 +0300
Message-ID: <CANfLQrbX4GmTbEuvnm+25bwCknB6DR2aQZN=0ZrHqdjCKXYYcw@mail.gmail.com> (sfid-20150908_095050_371939_B51AFE58)
Subject: Re: Fwd: bcmdhd: Concurrent use of wlan0 and virtual interface in
 managed mode
From: Gucea Doru <gucea.doru@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 8, 2015 at 12:01 AM, Arend van Spriel <arend@broadcom.com> wrote:

> The BCM4339 chip does not rely on mac80211. Instead, there is an
> 802.11 stack running on the device, ie. in firmware. The driver creates the
> primary interface, ie. wlan0. Additional P2P interfaces are created by
> wpa_supplicant.
>

Hm, BCM4339 uses the bcmdhd driver.
So the bcmdhd driver is not a softmac[1] driver and the the 802.11
processing is not done in software, right?

[1] https://wireless.wiki.kernel.org/en/developers/documentation/glossary#softmac

Regards,
Doru
