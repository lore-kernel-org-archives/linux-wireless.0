Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f43.google.com ([209.85.216.43]:49352 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932065Ab3GCJaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jul 2013 05:30:09 -0400
Received: by mail-qa0-f43.google.com with SMTP id d13so3441137qak.2
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jul 2013 02:30:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <51D3E2C7.7020605@kaiwen.me>
References: <51D3E2C7.7020605@kaiwen.me>
Date: Wed, 3 Jul 2013 15:00:08 +0530
Message-ID: <CAChKcE=1efYtv7TgmQCRi=LEKrCSYtUcd6xFHX6X=aRQ6XYoAw@mail.gmail.com> (sfid-20130703_113014_449152_77C66EBE)
Subject: Re: Use of 5GHz frequencies with Wi-Fi Direct
From: Gagan Goyal <gagsbond@gmail.com>
To: =?ISO-8859-1?Q?K=E9vin_THIERRY?= <kevin.thierry@kaiwen.me>
Cc: linux-wireless@vger.kernel.org, ronan lanoe <ronan.lanoe@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kevin,

Plz add the following entries in wpa_supplicant.conf to use freq 5180
as operating ch.

p2p_oper_reg_class=115
p2p_oper_channel=36
country=US

Check, if this solve the requirement.

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
