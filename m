Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:34822 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169AbcDLIzz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Apr 2016 04:55:55 -0400
Received: by mail-wm0-f50.google.com with SMTP id a140so44473049wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 12 Apr 2016 01:55:54 -0700 (PDT)
Subject: Re: [PATCH 0/8] brcmfmac: event handling and other fixes
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
References: <1460367328-12082-1-git-send-email-arend@broadcom.com>
 <CACna6rwCe6yfzcxdezKhPJwJ4cnWY4DEE04W81K=PrVD1pZVoA@mail.gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <570CB818.9080807@broadcom.com> (sfid-20160412_105600_653849_0E998F8B)
Date: Tue, 12 Apr 2016 10:55:52 +0200
MIME-Version: 1.0
In-Reply-To: <CACna6rwCe6yfzcxdezKhPJwJ4cnWY4DEE04W81K=PrVD1pZVoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11-04-16 13:20, Rafał Miłecki wrote:
> On 11 April 2016 at 11:35, Arend van Spriel <arend@broadcom.com> wrote:
>> This series provides the following:
>>
>> * avoid unexpected firmware events.
>> * allow passing events explicitly for PCIe and SDIO devices.
>> * fix issue with boardrev entry in nvram.
>> * fix for wowl.
>> * fix possible null pointer access upon aborting p2p scan.
>>
>> The series is intended for v4.7 kernel and applies to the master
>> branch of the wireless-drivers-next repository.
> 
> Hey Arend,
> 
> Unfortunately I'm finding all your recent messages in spam :( It seems
> GMail doesn't like something about the Broadcom server:
> "Why is this message in Spam? It has a from address in broadcom.com
> but has failed broadcom.com's required tests for authentication. Learn
> more"
> Quoted "Learn more" text links to the:
> https://support.google.com/mail/answer/1366858?hl=en-GB&expand=5
> 
> Do you think you can point it to sb at Broadcom?

sb? Help me understand this and I may have an appropriate answer :-p

Broadcom actually moved to Google Apps. I am still using my old email
address and smtp server for submitting patches. Maybe that is the issue
here.

Regards,
Arend
