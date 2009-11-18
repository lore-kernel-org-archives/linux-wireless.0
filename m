Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52283 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbZKRLbc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 06:31:32 -0500
Received: by bwz27 with SMTP id 27so984409bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 03:31:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258541631.30511.7.camel@johannes.local>
References: <1258509054-10901-1-git-send-email-janakiram.sistla@gmail.com>
	 <1258541631.30511.7.camel@johannes.local>
Date: Wed, 18 Nov 2009 17:01:36 +0530
Message-ID: <4fb5db50911180331n3e7a2d0fl73ec6a056eda1664@mail.gmail.com>
Subject: Re:
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 4:23 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2009-11-18 at 07:20 +0530, Janakiram Sistla wrote:
>
>> ---
>>  include/linux/rfkill.h |    2 ++
>>  net/rfkill/core.c      |    2 ++
>>  2 files changed, 4 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
>> index 3392c59..7ae75ef 100644
>> --- a/include/linux/rfkill.h
>> +++ b/include/linux/rfkill.h
>> @@ -35,6 +35,7 @@
>>   * @RFKILL_TYPE_UWB: switch is on a ultra wideband device.
>>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
>> + * @RFKILL_TYPE_FM: switch is on a wireless FM device.
>>   * @NUM_RFKILL_TYPES: number of defined rfkill types
>>   */
>>  enum rfkill_type {
>> @@ -44,6 +45,7 @@ enum rfkill_type {
>>       RFKILL_TYPE_UWB,
>>       RFKILL_TYPE_WIMAX,
>>       RFKILL_TYPE_WWAN,
>> +     RFKILL_TYPE_FM,
>>       RFKILL_TYPE_GPS,
>>       NUM_RFKILL_TYPES,
>>  };
>
> Nice try, but no fly. This struct is ABI, you cannot add in the middle.
Is it ok if i can add my change after RFKILL_TYPE_GPS.But with respect
to the change i made i also made the necessary changes in core.c.

>
> johannes
>
