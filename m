Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2709 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758931Ab3EGIou (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 04:44:50 -0400
Message-ID: <5188B732.3010403@broadcom.com> (sfid-20130507_104505_708635_5844D31A)
Date: Tue, 7 May 2013 10:11:30 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Larry Finger" <Larry.Finger@lwfinger.net>
cc: "Vasiliy Tolstov" <v.tolstov@selfip.ru>,
	"Julian Calaby" <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: very bad work of wl (bcm 43228)
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
 <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
 <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
 <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com>
 <517199D4.9070702@broadcom.com>
 <CACaajQuC3QpcEVnDZA7nCJ_6mmSNafn5zZp=QMdomzHUQ7AsSQ@mail.gmail.com>
 <CACaajQtbR5Utac82Zik00dQZYiE=tcDRmhWDt17BYEHDOj1Z2w@mail.gmail.com>
 <517A427E.3010809@broadcom.com>
 <CACaajQsf8cgG9DQ-QuWY5EqeUNq4RgX9CMgQ8bZi7s8UJzCE_g@mail.gmail.com>
 <CACaajQuk359fYap=547qQ0r128bdCuzFCzR=iXgHNaaR_eTtow@mail.gmail.com>
 <5186D7AD.1070702@lwfinger.net>
 <CACaajQuSU4H0rdn9j7dFYB+Yh2WLsejocDfE+PX1eFQOUqWcgw@mail.gmail.com>
 <5187CCCB.1080500@lwfinger.net>
In-Reply-To: <5187CCCB.1080500@lwfinger.net>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2013 05:31 PM, Larry Finger wrote:
> On 05/06/2013 05:45 AM, Vasiliy Tolstov wrote:
>> 2013/5/6 Larry Finger <Larry.Finger@lwfinger.net>:
>>> You are using a closed-source driver. None of us know what is in the
>>> code,
>>> thus there is very little help we can give you other than to give
>>> general
>>> suggestions. If you were using b43 or brcmsmac, the situation would be
>>> different.
>>
>>
>> Yes, but on last message i get response from broadcom and expect to
>> see his answers.
>> May be broadcom has own mailing list for bad things in their drivers?
>
> My impression was that you were given a general answer, but that no
> specific suggestions could be made. I don't think you should expect any
> more help from the open-source community.

The only specific suggestion given by me was to turn off powersave, but 
that was already tried. My knowledge of wl linux-sta driver is limited.

> I am not aware of any mailing list for complaints about wl, but I never
> use it.

Actually, there is: linux-wlan-client-support-list@broadcom.com

It can be found on the web page [1].

Regards,
Arend

[1] http://www.broadcom.com/support/802.11/linux_sta.php

