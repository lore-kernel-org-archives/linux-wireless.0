Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49160 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757454AbZKRPzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Nov 2009 10:55:01 -0500
Received: by bwz27 with SMTP id 27so1269661bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 18 Nov 2009 07:55:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1258558500.2003.88.camel@violet>
References: <1258557771-10776-1-git-send-email-janakiram.sistla@gmail.com>
	 <1258558500.2003.88.camel@violet>
Date: Wed, 18 Nov 2009 21:25:06 +0530
Message-ID: <4fb5db50911180755u4e01814bvcc4d0ec8d396abd@mail.gmail.com>
Subject: Re: [PATCH 2/2] Adding kerneldoc entry for radio type GPS
From: Janakiram Sistla <janakiram.sistla@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 18, 2009 at 9:05 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi guys,
>
>> From: Janakiram Sistla <janakiram.sistla@gmail.com>
>>
>>
>> Signed-off-by: Janakiram Sistla <janakiram.sistla@gmail.com>
>> ---
>>  include/linux/rfkill.h |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/rfkill.h b/include/linux/rfkill.h
>> index d787d5f..212f555 100644
>> --- a/include/linux/rfkill.h
>> +++ b/include/linux/rfkill.h
>> @@ -36,6 +36,7 @@
>>   * @RFKILL_TYPE_WIMAX: switch is on a WiMAX device.
>>   * @RFKILL_TYPE_WWAN: switch is on a wireless WAN device.
>>   * @RFKILL_TYPE_FM: switch is on a FM device.
>> + * @RFKILL_TYPE_GPS: switch is on a GPS device.
>>   * @NUM_RFKILL_TYPES: number of defined rfkill types
>>   */
>>  enum rfkill_type {
>
> so this is getting stupid right now. I am sick of a really simple patch
> causes so much trouble. Even this one is wrong again. The GPS doc should
> obviously before FM.
Marcel I think you want me to submit GPS doc patch first.I will be
doing it shortly and then i will do it for FM.I am sorry for this mis
understanding
>
> Regards
>
> Marcel
>
>
>

Regards,
Ram.
