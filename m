Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f50.google.com ([209.85.212.50]:36214 "EHLO
	mail-vb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752066Ab3EEWFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 May 2013 18:05:37 -0400
Received: by mail-vb0-f50.google.com with SMTP id w16so2539868vbb.9
        for <linux-wireless@vger.kernel.org>; Sun, 05 May 2013 15:05:36 -0700 (PDT)
Message-ID: <5186D7AD.1070702@lwfinger.net> (sfid-20130506_000550_708899_DBB4DAF6)
Date: Sun, 05 May 2013 17:05:33 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Vasiliy Tolstov <v.tolstov@selfip.ru>
CC: Arend van Spriel <arend@broadcom.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: very bad work of wl (bcm 43228)
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com> <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com> <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com> <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com> <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com> <517199D4.9070702@broadcom.com> <CACaajQuC3QpcEVnDZA7nCJ_6mmSNafn5zZp=QMdomzHUQ7AsSQ@mail.gmail.com> <CACaajQtbR5Utac82Zik00dQZYiE=tcDRmhWDt17BYEHDOj1Z2w@mail.gmail.com> <517A427E.3010809@broadcom.com> <CACaajQsf8cgG9DQ-QuWY5EqeUNq4RgX9CMgQ8bZi7s8UJzCE_g@mail.gmail.com> <CACaajQuk359fYap=547qQ0r128bdCuzFCzR=iXgHNaaR_eTtow@mail.gmail.com>
In-Reply-To: <CACaajQuk359fYap=547qQ0r128bdCuzFCzR=iXgHNaaR_eTtow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/05/2013 03:30 PM, Vasiliy Tolstov wrote:
> 2013/4/27 Vasiliy Tolstov <v.tolstov@selfip.ru>:
>> 2013/4/26 Arend van Spriel <arend@broadcom.com>:
>>> Not really. You could try disabling powersave. I am not very familiar with
>>> wl driver.
>>>
>>> $ iw dev wlanX power_save off
>>>
>>> Can you still provide lsusb and lspci for all devices?
>>>
>>> Gr. AvS
>
>
> Any news?

You are using a closed-source driver. None of us know what is in the code, thus 
there is very little help we can give you other than to give general 
suggestions. If you were using b43 or brcmsmac, the situation would be different.

Larry


