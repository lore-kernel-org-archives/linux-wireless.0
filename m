Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:49960 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbaLSNTR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2014 08:19:17 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so626478iec.25
        for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2014 05:19:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54940B8C.5070801@neratec.com>
References: <CAGXE3d8Uv01qjfvRQkMr1w_5wB6XKpC7d2VOR3UG0DMPHk6r9A@mail.gmail.com>
	<54940B8C.5070801@neratec.com>
Date: Fri, 19 Dec 2014 14:19:17 +0100
Message-ID: <CAGXE3d9ZubxEoeV+uD9GHJiAa7aB_NM87OfddNa4SC5CQkjNuA@mail.gmail.com> (sfid-20141219_141923_127108_8E3908A1)
Subject: Re: DFS CAC time
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Zefir,

On Fri, Dec 19, 2014 at 12:27 PM, Zefir Kurtisi
<zefir.kurtisi@neratec.com> wrote:
> On 12/18/2014 05:21 PM, Helmut Schaa wrote:
>> Hi,
>>
>> [...]
>>
>> So, every channel has a CAC time of 60 seconds.
>>
>> Checking version 1.7.2 of the ETSI regulation indicates that we might
>> need some modifications to cfg80211:
>>
>> From [1] page 79:
>>
>> "NOTE 1: For channels whose nominal bandwidth falls completely or
>> partly within the
>> band 5 600 MHz to 5 650 MHz, the Channel Availability Check Time shall be
>> 10 minutes.
>> NOTE 2: For channels whose nominal bandwidth falls completely or
>> partly within the
>> band 5 600 MHz to 5 650 MHz, the Off-Channel CAC Time shall be within the
>> range 1 hour to 24 hours."
>>
>> So, for these channels we should select a longer initial CAC time.
>>
>> Is anyone aware of this issue?
>>
>> Thanks,
>> Helmut
>>
>>
>> [1] http://www.etsi.org/deliver/etsi_en/301800_301899/301893/01.07.02_20/en_301893v010702a.pdf
>> --
>
> Hello Helmut,
>
> just forget about those aka 'weather channels' that require a pracitcally
> impossible to achieve radar detection probability rate (99.99% during CAC, see
> table D.5).

Hmm, ok :)

Would it make sense to mark these somehow in the wireless-regdb in a
special way?

Thanks,
Helmut
