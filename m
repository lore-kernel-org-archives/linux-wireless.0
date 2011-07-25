Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45526 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752119Ab1GYUdQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jul 2011 16:33:16 -0400
Received: by qyk9 with SMTP id 9so2624240qyk.19
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jul 2011 13:33:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <COL114-W59BDCD7915EEDAF4BEE71A8A4E0@phx.gbl>
References: <COL114-W9CEFD4E7F3803005186F98A4F0@phx.gbl> <COL114-W59BDCD7915EEDAF4BEE71A8A4E0@phx.gbl>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 25 Jul 2011 13:32:55 -0700
Message-ID: <CAB=NE6WoKhvR7AVcwaGkijkph+UAts9h-=L4oPwhE=b6gW8eDg@mail.gmail.com> (sfid-20110725_223324_915482_3348FC78)
Subject: Re: problem on ACS
To: MingAnn Ng <devil_eddie01@hotmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 21, 2011 at 8:13 PM, MingAnn Ng <devil_eddie01@hotmail.com> wrote:
> Hi Luis,
>
> I am thinking of using the ACS application for channel selection on IBSS
> network. I had run a test with the current git. But the result is not so
> convincing.
>
>    10 surveys for 2412 MHz: 11.382248 12.847997 13.223471 13.403065
> 13.454694 13.529891 12.556324 13.573309 13.616969 13.645601
>    10 surveys for 2417 MHz: 12.678072 10.299560 -inf -inf 9.678072 -inf -inf
> -inf -inf -inf
>    10 surveys for 2422 MHz: -inf -inf -inf -inf -inf -inf -inf -inf -inf
> -inf
>    10 surveys for 2427 MHz: -inf -inf 12.192645 -inf -inf -inf -inf -inf
> -inf -inf
>    10 surveys for 2432 MHz: -inf 9.192645 12.777608 12.192645 12.192645 -inf
> 12.192645 -inf 10.093109 12.192645
>    10 surveys for 2437 MHz: 11.192645 -inf 11.000000 10.093109 10.093109
> 11.192645 -inf 11.192645 -inf -inf
>    10 surveys for 2442 MHz: 10.192645 10.093109 -inf 10.061401 11.192645
> -inf -inf -inf 11.192645 10.093109
>    10 surveys for 2447 MHz: -inf -inf -inf 11.777608 -inf 10.192645 -inf
> -inf -inf -inf
>    10 surveys for 2452 MHz: 11.192645 -inf -inf 11.192645 -inf -inf -inf
> 13.777608 11.337035 10.830075
>    10 surveys for 2457 MHz: 10.192645 -inf -inf -inf -inf -inf -inf -inf
> -inf -inf
>    10 surveys for 2462 MHz: 9.540568 9.192645 10.283793 8.476438 -inf -inf
> -inf -inf 10.192645 -inf
>    10 surveys for 2467 MHz: -inf -inf -inf -inf -inf -inf 9.752072 -inf -inf
> -inf
>    10 surveys for 2472 MHz: -inf -inf 10.192645 -inf -inf -inf -inf -inf
> 7.714598 -inf
>    10 surveys for 5180 MHz: 2.000000 1.830075 1.000000 0.678072 2.000000
> 2.000000 2.000000 0.678072 2.000000 2.000000
>    10 surveys for 5200 MHz: 2.000000 1.678072 2.000000 2.000000 2.000000
> 2.000000 1.678072 2.000000 0.678072 0.678072
>    10 surveys for 5220 MHz: 2.000000 1.415037 2.000000 0.000000 2.000000
> 2.000000 1.678072 2.000000 2.000000 2.000000
>    10 surveys for 5240 MHz: 3.000000 3.000000 3.000000 1.245112 3.000000
> 3.000000 3.000000 2.678072 2.000000 3.000000
>    10 surveys for 5260 MHz: 3.000000 2.000000 3.000000 3.000000 3.000000
> 3.000000 2.000000 2.678072 2.000000 2.678072
>    10 surveys for 5280 MHz: 3.000000 1.415037 3.000000 1.415037 1.678072
> 2.000000 1.245112 3.000000 3.000000 2.678072
>    10 surveys for 5300 MHz: 3.000000 3.000000 3.000000 1.415037 3.000000
> 3.000000 3.000000 2.000000 3.000000 3.000000
>    10 surveys for 5320 MHz: 3.000000 3.000000 3.000000 3.000000 3.000000
> 2.678072 3.000000 1.415037 3.000000 2.000000
>    10 surveys for 5500 MHz: -1.000000 -2.000000 -1.000000 -2.321928
> -1.321928 -1.321928 -1.000000 -2.321928 -1.000000 -2.459432
>    10 surveys for 5520 MHz: -2.392317 -1.169925 -1.169925 -0.807355
> -1.906891 -1.169925 -1.169925 -1.169925 -1.700440 -0.807355
>    10 surveys for 5540 MHz: -1.169925 -2.643856 -1.169925 -2.087463
> -1.169925 -1.169925 -2.523562 -1.169925 -1.169925 -1.169925
>    10 surveys for 5560 MHz: -1.169925 -1.169925 -2.643856 -1.169925
> -1.321928 -1.169925 -1.459432 -1.700440 -2.087463 -1.169925
>    10 surveys for 5580 MHz: -1.169925 -1.700440 -1.169925 -1.906891
> -1.321928 -1.169925 -1.169925 -1.169925 -1.169925 -1.169925
>    10 surveys for 5600 MHz: -1.169925 -1.169925 -1.169925 -2.643856
> -0.807355 -2.459432 -1.459432 -1.169925 -1.169925 -1.169925
>    10 surveys for 5620 MHz: -1.169925 -1.321928 -2.087463 -1.169925
> -1.169925 -1.321928 -0.807355 -2.392317 -1.169925 -1.169925
>    10 surveys for 5640 MHz: -2.643856 -1.321928 -1.169925 -2.857981
> -1.169925 -0.584963 -1.169925 -1.169925 -1.169925 -3.643856
>    10 surveys for 5660 MHz: -2.169925 -1.584963 -2.169925 -2.857981
> -1.169925 -1.169925 -1.169925 -1.169925 -1.459432 -1.169925
>    10 surveys for 5680 MHz: -1.169925 -1.169925 -2.643856 -2.700440
> -1.169925 -1.169925 -1.169925 -1.169925 -0.807355 -1.700440
>    10 surveys for 5700 MHz: -2.087463 -1.169925 -1.169925 -1.000000
> -2.459432 -1.169925 -1.169925 -1.169925 -1.169925 -1.169925
> 2412 MHz: 13.123357
> 2417 MHz: -inf
> 2422 MHz: -inf
> 2427 MHz: -inf
> 2432 MHz: -inf
> 2437 MHz: -inf
> 2442 MHz: -inf
> 2447 MHz: -inf
> 2452 MHz: -inf
> 2457 MHz: -inf
> 2462 MHz: -inf
> 2467 MHz: -inf
> 2472 MHz: -inf
> 5180 MHz: 1.618622
> 5200 MHz: 1.671229
> 5220 MHz: 1.709311
> 5240 MHz: 2.692318
> 5260 MHz: 2.635614
> 5280 MHz: 2.243133
> 5300 MHz: 2.741504
> 5320 MHz: 2.709311
> 5500 MHz: -1.574714
> 5520 MHz: -1.346398
> 5540 MHz: -1.544436
> 5560 MHz: -1.506274
> 5580 MHz: -1.311873
> 5600 MHz: -1.438962
> 5620 MHz: -1.378062
> 5640 MHz: -1.690221
> 5660 MHz: -1.609185
> 5680 MHz: -1.487164
> 5700 MHz: -1.373637
> Ideal freq: 2417 MHz
>
>
> The ideal channel is 2417MHz. But there are many interference in 2.4G at my
> testing place. the result for that channel is -inf.

Right..

> I did not understand the
> outcome, maybe you can describe about -infinity and why that this result
> occurs.

Sure, so -inf means the calculation resulted in a value out of bounds
by the used data type. The issue lies in the wide range of values that
we run into for analysis in very noisy environments. One alternative I
considered was to use __float128 instead of long double for the
interference_factor but I was unable to figure out how to print these
correctly.

> will it be causing by scanning time for particular channel is too
> short?

Can you test with the latest ACS patches I posted for hostapd with
debugging and see the values you get there?

  Luis
