Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:65370 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0DIVc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 17:32:57 -0400
Received: by pva18 with SMTP id 18so2332746pva.19
        for <linux-wireless@vger.kernel.org>; Fri, 09 Apr 2010 14:32:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270846132.23853.35.camel@mj>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	<1270754858-26266-32-git-send-email-lrodriguez@atheros.com>
	<1270846132.23853.35.camel@mj>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 9 Apr 2010 17:32:37 -0400
Message-ID: <p2v43e72e891004091432ga3f5df1ja7d55eaa092a5c71@mail.gmail.com>
Subject: Re: [PATCH 031/102] ath9k_hw: run Lindent on intivals
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 9, 2010 at 4:48 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-04-08 at 15:26 -0400, Luis R. Rodriguez wrote:
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h | 1495 ++--
>>  drivers/net/wireless/ath/ath9k/ar9001_initvals.h | 2432 +++--
>>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h |12659 +++++++++++++---------
>>  3 files changed, 9658 insertions(+), 6928 deletions(-)
>>
>> diff --git a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>> index cd953f6..ba899f9 100644
>> --- a/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>> +++ b/drivers/net/wireless/ath/ath9k/ar5008_initvals.h
>> @@ -18,725 +18,856 @@
>>  #define INITVALS_AR5008_H
>>
>>  static const u32 ar5416Modes[][6] = {
>> -    { 0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160, 0x000001e0 },
> ...
>> +     {0x00001030, 0x00000230, 0x00000460, 0x000002c0, 0x00000160,
>> +      0x000001e0},
>
> That's hardly an improvement.
>
> Actually, it should be possible to strip the first 4 zeroes from the
> first value (the register number), and then there will be no wrapping.
>
> The only exceptions are
>
>    { 0x00020010, 0x00000003 },
>    { 0x00020038, 0x000004c2 },
>
> in ar5416Common_9100.  They look suspicious, by the way.  But even
> stripping 3 zeroes should be enough.

Good idea.

  Luis
