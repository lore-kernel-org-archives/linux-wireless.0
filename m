Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:57188 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3FEHVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Jun 2013 03:21:15 -0400
Received: by mail-wi0-f175.google.com with SMTP id hn14so4513857wib.8
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jun 2013 00:21:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPsaeQOe0O56whfn1cUvjz46WS7A=6qRh0eu5C2QhO70o7d9Ug@mail.gmail.com>
References: <CAJ-Vmo=2oBy7kVN5dTx1TLfEER77tOYQXTz6WoG6Q=4A0kOgmw@mail.gmail.com>
	<CAPsaeQOe0O56whfn1cUvjz46WS7A=6qRh0eu5C2QhO70o7d9Ug@mail.gmail.com>
Date: Wed, 5 Jun 2013 00:21:13 -0700
Message-ID: <CAJ-Vmonj=N2LsxXxFTjDKi6sxZEN_PueQV4KSiVqWVAnfe1deQ@mail.gmail.com> (sfid-20130605_092125_126657_DE72F496)
Subject: Re: [ath9k-devel] 4.9GHz and 5.8GHz regulatory entries?
From: Adrian Chadd <adrian@freebsd.org>
To: Josef Semler <josef.semler@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

What's the FCC rules for 5.8ghz atm?



adrian

On 4 June 2013 21:41, Josef Semler <josef.semler@gmail.com> wrote:
> Hi Adrian,
> I've done a modification for 5.8 ghz and some outdoor tests usin
> ubnt-hardware.
> Joe
>
> Am Mittwoch, 5. Juni 2013 schrieb Adrian Chadd :
>>
>> Hi all,
>>
>> I'm hacking at the support needed for 4.9 and 5.8GHz NICs in FreeBSD.
>> Well, there's support for them (and they work!) but I'm doing up some
>> regulatory entries for them.
>>
>> So, has anyone looked at adding 4.9 and 5.8GHz regulatory domain
>> entries to db.txt in Linux, for regulatory domains that allow them to
>> be used unlicenced?
>>
>> Thanks,
>>
>>
>>
>> Adrian
>> _______________________________________________
>> ath9k-devel mailing list
>> ath9k-devel@lists.ath9k.org
>> https://lists.ath9k.org/mailman/listinfo/ath9k-devel
