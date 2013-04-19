Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1076 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753445Ab3DSTZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 15:25:30 -0400
Message-ID: <517199D4.9070702@broadcom.com> (sfid-20130419_212537_333305_A2EF132F)
Date: Fri, 19 Apr 2013 21:24:04 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Vasiliy Tolstov" <v.tolstov@selfip.ru>
cc: "Julian Calaby" <julian.calaby@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	=?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"Larry Finger" <larry.finger@lwfinger.net>
Subject: Re: very bad work of wl (bcm 43228)
References: <CACaajQtmPLHBStjPT4L5pa6s2nVC2zwxCa3v+Z10ZBFCXp+dDw@mail.gmail.com>
 <CAGRGNgX0P8+6xT-hi81Y+gE47ZD2JPRuD=4TeXePHC_2bQhxSg@mail.gmail.com>
 <CACaajQusznz4ATwN35i8S=NRbYnuRR0GF=1TE89Mpi3dmyKaDA@mail.gmail.com>
 <CAGRGNgWEDjzP5GG6ZJHQ4tc+G+hKdJdateAc13NppEMaDckGHA@mail.gmail.com>
 <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com>
In-Reply-To: <CACaajQvv975G0oOu73aWxfy3iQLiV2gtkzk-E3jhBcOjZxa+pA@mail.gmail.com>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/19/2013 01:20 PM, Vasiliy Tolstov wrote:
> 2013/4/19 Julian Calaby <julian.calaby@gmail.com>:
>> There are two ways that support for your card will happen:
>> 1. The b43 developers will finish reverse engineering it and release
>> support for it.
>> 2. Broadcom will release support through the brcmsmac driver.
>>
>>
>> Option 2 may take some time as we're waiting for Broadcom. Arend is
>> their main person here, I've also CC'd him.
>>
>
> Hmm , as i see broadcom not very interesting with opensource =( (i
> have broadcom cardreader in my
> notebook and its not respond when insert card..., bug stays open...)

Hmm, I see things differently, but I may be biased ;-) Broadcom is a 
sizeable company with different business units. I was not even aware we 
were providing cardreaders. My focus is on wireless devices.

Option 2 is on our todo list, but other tasks (brcmfmac) have taken 
priority and still are.

>> If you're desperate for a good wireless connection on that laptop
>> right now, your best bet is to buy yourself a cheap USB card, I
>> personally recommend ones with Atheros chipsets as they're very well
>> supported and tend to work well. TP-Link make some cheap  and good
>> ones like the TL-WN821N and TL-WN822N.
>
> Thanks. But IMHO i have adapter with bluetooth and wifi integrated (as
> i think) and buy wifi+bluetooth in russia not very simple =)

I have no quick solution so need to more detailed info. For these kind 
of questions it always helps to provide kernel log and output from 
commands like lspci and lsusb.

Regards,
Arend


