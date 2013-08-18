Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:42199 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755400Ab3HRXh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Aug 2013 19:37:56 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so4264188pbc.3
        for <linux-wireless@vger.kernel.org>; Sun, 18 Aug 2013 16:37:55 -0700 (PDT)
Message-ID: <52115ACE.9070801@gna.org> (sfid-20130819_013805_988891_BFBC51B4)
Date: Mon, 19 Aug 2013 11:37:50 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: Oleksij Rempel <linux@rempel-privat.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>
Subject: Re: [TL-WN721N] No disconnect notification when AP is gone
References: <520D6058.7040405@gna.org> <520DCF1E.7040808@rempel-privat.de>
In-Reply-To: <520DCF1E.7040808@rempel-privat.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16/08/13 19:05, Oleksij Rempel wrote:
> Am 16.08.2013 01:12, schrieb Christian Gagneraud:
>> Hi there,
>>
>> I'm using a TP-LINK TL-WN721N, and experience a strange behaviour, I'm
>> running Ubuntu 13.04 (3.8.0-27-generic + backports-3.11-rc3-1).
>>
>> The problem is that if I am connected to my AP and then power it off, I
>> never receive a disconnect notification.
>>
>> I first reported the bug to the connman mailing list [1], but it was
>> suggested there that it could be a bug in the device driver.
>>
>> At first I was using the Ubuntu kernel modules, but before reporting any
>> bugs, I switched to backports-3.11-rc3-1, and I still have the problem.
>>
>> Any thoughts?
>>
>> Regards,
>> Chris
>>
>> [1] Latest messages haven't been archived  yet, but:
>>   https://lists.connman.net/pipermail/connman/2013-August/015401.html
>
> I assume it is Atheros ar9271 based adapter. Did you tried to use latest
> firmware?
> https://github.com/qca/open-ath9k-htc-firmware

Yes, it is.

I have just tried latest firmware from git, it is still not working as 
expected. Ubuntu 13.04 comes by default with FW v1.3, I can confirm that 
I really used the new one, as now the kernel tells me it is FW v1.4 
(before it was 1.3).

Should I open an issue ticket on open-ath9k-htc-firmware? How can I make 
sure where the problem comes from?


Regards,
Chris


>
> If you have some time, i'll suggest you to investigate this issue so far
> you can by your self.
>

