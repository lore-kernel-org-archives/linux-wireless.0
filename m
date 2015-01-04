Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:58438 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752664AbbADMoB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2015 07:44:01 -0500
Received: by mail-ie0-f180.google.com with SMTP id rp18so17788600iec.25
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 04:44:00 -0800 (PST)
Received: from mail-ie0-f175.google.com (mail-ie0-f175.google.com. [209.85.223.175])
        by mx.google.com with ESMTPSA id tg9sm2191414igb.8.2015.01.04.04.43.59
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 04 Jan 2015 04:43:59 -0800 (PST)
Received: by mail-ie0-f175.google.com with SMTP id x19so18437783ier.20
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2015 04:43:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A8DBF4.4050202@lwfinger.net>
References: <1420332469-5907-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<54A8DBF4.4050202@lwfinger.net>
Date: Sun, 4 Jan 2015 13:43:59 +0100
Message-ID: <CAKXHbyN6LH_pFw1uoLXRzgJv-NcjbTLJvMZXfwYXDwuk9QDszA@mail.gmail.com> (sfid-20150104_134406_966806_4480E20D)
Subject: Re: [PATCH] brcm80211: brcmsmac: dma: Remove some unused functions
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Kalle Valo <kvalo@adurom.com>,
	Fabian Frederick <fabf@skynet.be>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list@broadcom.com,
	Network Development <netdev@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2015-01-04 7:21 GMT+01:00 Larry Finger <Larry.Finger@lwfinger.net>:
> On 01/03/2015 06:47 PM, Rickard Strandqvist wrote:
>>
>> Removes some functions that are not used anywhere:
>> dma_txflush() dma_txsuspended()
>>
>> This was partially found by using a static code analysis program called
>> cppcheck.
>>
>> Signed-off-by: Rickard Strandqvist
>> <rickard_strandqvist@spectrumdigital.se>
>> ---
>>   drivers/net/wireless/brcm80211/brcmsmac/dma.c |   19 -------------------
>>   drivers/net/wireless/brcm80211/brcmsmac/dma.h |    2 --
>>   2 files changed, 21 deletions(-)
>
>
> Just because file dma.c is involved, it does not need to be, nor should it
> be in the subject line. You could specify the driver names in the file tree
> after wireless. In this instance, one possible subject would be "brcm80211:
> brcmsmac: Remove some unused functions". On the other hand, if you look at
> "git log" to see past patches, the driver maintainers even leave off the
> brcm80211 part, thus to match them, the subject should be "brcmsmac: Remove
> some unused functions".
>
> As was suggested earlier, you need to look at the precedents. Keeping a
> uniform method of patch naming helps when looking for patches in the git
> log.
>
> Larry
>


Hi Larry

As I hope you can see I have made some changes regarding the
subject-line. Thought it was an advantage to be able to see which file
I actually removed something from.
There seems to be a big focus on getting right on subject-line right
in recent weeks.

I wonder why there is a script that takes a file name, and respond
with an appropriate subject line?

But ok, I change my script accordingly. Should I submit the patch again?


Kind regards
Rickard Strandqvist
