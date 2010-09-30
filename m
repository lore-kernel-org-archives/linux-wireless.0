Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54710 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab0I3NXu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 09:23:50 -0400
Received: by wyb28 with SMTP id 28so1836744wyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 06:23:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100928194742.GB5307@tuxdriver.com>
References: <1284739766-31231-1-git-send-email-mshajakhan@atheros.com>
	<20100928194742.GB5307@tuxdriver.com>
Date: Thu, 30 Sep 2010 18:53:49 +0530
Message-ID: <AANLkTikcWuoHb4fTudPnkDV-V4+z9mzjaGCRUO=sm9_z@mail.gmail.com>
Subject: Re: [PATCH v2] ath9k : Fix for displaying the channel number
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry John ,had sent the patch which was created with the old tree
,will  soon a send a proper patch.
sorry for the inconvenience.

shafi

On Wed, Sep 29, 2010 at 1:17 AM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Fri, Sep 17, 2010 at 09:39:26PM +0530, Mohammed Shafi Shajakhan wrote:
>> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>>
>> In the ath9k debugging feature 'wiphy' the current channel used by the
>> station is incorrectly displayed.This is because the channels available
>> are sequentially mapped from numbers 0 to 37.This mapping cannot be
>> changed as the channel number is also used as an index for an array of
>> structures in struct ath9k_channel channels[38] .
>>           This fix solves the above problem by calculating the channel
>> number from center frequency.
>>
>> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>
> What was this patch based against?  It doesn't seem to apply anymore...
>
> John
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
