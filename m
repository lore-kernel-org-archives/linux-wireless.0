Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:33957 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbbIHJYo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Sep 2015 05:24:44 -0400
Message-ID: <55EEA958.4060300@broadcom.com> (sfid-20150908_112453_130768_50994F98)
Date: Tue, 8 Sep 2015 11:24:40 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Gucea Doru <gucea.doru@gmail.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: Fwd: bcmdhd: Concurrent use of wlan0 and virtual interface in
 managed mode
References: <CANfLQrbXn2pLjVY8DVC=xs9oWZC2nX3VcEZQMLh1zQa7i4EHCg@mail.gmail.com>	<55DAD0FD.3070807@broadcom.com>	<CANfLQrYQnk6bUjPEKxucxBhLvsRsqpfydvAkvsvKdg0nnte3iA@mail.gmail.com>	<CAG8K7gRdXqpfA3_HPoaM+ivgxH4eiPRWkD238QwMMbNigYHDBw@mail.gmail.com>	<CANfLQraZAkw0Eqt-Mog5t4ZfGFx3xm_8-6nJoJ68Mim18bW3Tg@mail.gmail.com>	<CANfLQrYVq_eMa-CLJhqVthbm_h7yLBhZN5nm0_f70eEob+rUdw@mail.gmail.com>	<55EDFB26.8000708@broadcom.com> <CANfLQrbX4GmTbEuvnm+25bwCknB6DR2aQZN=0ZrHqdjCKXYYcw@mail.gmail.com>
In-Reply-To: <CANfLQrbX4GmTbEuvnm+25bwCknB6DR2aQZN=0ZrHqdjCKXYYcw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/08/2015 09:50 AM, Gucea Doru wrote:
> On Tue, Sep 8, 2015 at 12:01 AM, Arend van Spriel <arend@broadcom.com> wrote:
>
>> The BCM4339 chip does not rely on mac80211. Instead, there is an
>> 802.11 stack running on the device, ie. in firmware. The driver creates the
>> primary interface, ie. wlan0. Additional P2P interfaces are created by
>> wpa_supplicant.
>>
>
> Hm, BCM4339 uses the bcmdhd driver.
> So the bcmdhd driver is not a softmac[1] driver and the the 802.11
> processing is not done in software, right?

Sure it is done in software. Just not on the host, ie. in linux kernel, 
but on the device.

Regards,
Arend

> [1] https://wireless.wiki.kernel.org/en/developers/documentation/glossary#softmac
>
> Regards,
> Doru
>

