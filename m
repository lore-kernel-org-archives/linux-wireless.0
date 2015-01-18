Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:46627 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbbARQls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Jan 2015 11:41:48 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so27550813iec.10
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 08:41:47 -0800 (PST)
Received: from mail-ie0-f171.google.com (mail-ie0-f171.google.com. [209.85.223.171])
        by mx.google.com with ESMTPSA id n13sm426619ioi.24.2015.01.18.08.41.46
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 18 Jan 2015 08:41:46 -0800 (PST)
Received: by mail-ie0-f171.google.com with SMTP id ar1so27646240iec.2
        for <linux-wireless@vger.kernel.org>; Sun, 18 Jan 2015 08:41:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20150117215839.GA18538@kroah.com>
References: <1419166779-2619-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<20150117215839.GA18538@kroah.com>
Date: Sun, 18 Jan 2015 17:41:46 +0100
Message-ID: <CAKXHbyMjJUUYcSqvoE4eC_BdCEH1Lh3vLqCTaOf3GDvsKaQcjQ@mail.gmail.com> (sfid-20150118_174205_883142_243BA3F4)
Subject: Re: [PATCH] staging: rtl8723au: hal: rtl8723au_led.c: Remove some
 unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-17 22:58 GMT+01:00 Greg Kroah-Hartman <gregkh@linuxfoundation.org>:
> On Sun, Dec 21, 2014 at 01:59:39PM +0100, Rickard Strandqvist wrote:
>> Removes some functions that are not used anywhere:
>> rtl8723au_DeInitSwLeds() rtl8723au_InitSwLeds()
>>
>> This was partially found by using a static code analysis program called cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> ---
>>  drivers/staging/rtl8723au/hal/rtl8723au_led.c    |   23 ----------------------
>>  drivers/staging/rtl8723au/include/rtl8723a_led.h |    2 --
>>  2 files changed, 25 deletions(-)
>
> These files aren't even in the tree anymore :(


Hi

No right. I can not find the files.
And can not find these functions anywhere anymore.

Sorry about that :(

Kind regards
Rickard Strandqvist
