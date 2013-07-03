Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f45.google.com ([209.85.216.45]:48414 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932454Ab3GCJ7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 05:59:30 -0400
Received: by mail-qa0-f45.google.com with SMTP id ci6so3456150qab.18
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 02:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51D3E2C7.7020605@kaiwen.me>
References: <51D3E2C7.7020605@kaiwen.me>
Date: Wed, 3 Jul 2013 15:29:29 +0530
Message-ID: <CAChKcEmU9MMrC4gP4Vi3WWENTAC4+rtDK6mxA=5phdsEDxipxQ@mail.gmail.com> (sfid-20130703_115932_952221_612BFFB9)
Subject: Re: Use of 5GHz frequencies with Wi-Fi Direct
From: Gagan Goyal <gagsbond@gmail.com>
To: =?ISO-8859-1?Q?K=E9vin_THIERRY?= <kevin.thierry@kaiwen.me>
Cc: linux-wireless@vger.kernel.org, ronan lanoe <ronan.lanoe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

plz make sure that driver advertise the support for both the bands and
provide all the supported frequencies.

During Supplicant init, supplicant read the driver capabilities and
along with other things the supported band and frequencies are stored.

P2p global data is then initialized with same data.

Cheers

Gagan

On 7/3/13, Kévin THIERRY <kevin.thierry@kaiwen.me> wrote:
> Hi,
>
> Is there a way to force the use of 5GHz frequencies with Wi-Fi Direct ?
> (Or define the 5GHz frequencies as preferred ?)
>
> I tried to add the freq_list option in wpa_supplicant config file
> without success. (I think this option should be set in a network block
> but there is no network block for Wi-Fi Direct...)
> "freq_list=5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 5560
> 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825"
>
> Thanks,
>
> Kevin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
