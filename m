Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:50530 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492AbZHOWHW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Aug 2009 18:07:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so2035971and.1
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2009 15:07:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <69e28c910908150513v10a4ad8dh8f40fe8fbff2a533@mail.gmail.com>
References: <1250281559-13041-1-git-send-email-lrodriguez@atheros.com>
	<1250281559-13041-24-git-send-email-lrodriguez@atheros.com>
	<69e28c910908150513v10a4ad8dh8f40fe8fbff2a533@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Sat, 15 Aug 2009 15:07:03 -0700
Message-ID: <43e72e890908151507i253fa206o9465e8d96543f71f@mail.gmail.com>
Subject: Re: [PATCH v4 23/34] wireless: downgrade TI driver from menuconfig to
	config
To: =?UTF-8?Q?G=C3=A1bor_Stefanik?= <netrolller.3d@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Larry.Finger@lwfinger.net, Kalle Valo <kalle.valo@nokia.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/15 Gábor Stefanik <netrolller.3d@gmail.com>:
> On Fri, Aug 14, 2009 at 10:25 PM, Luis R.
> Rodriguez<lrodriguez@atheros.com> wrote:
>> There's only a few options here so let this expand upon
>> selection.
>>
>> Cc: Kalle Valo <kalle.valo@nokia.com>
>> Acked-by: Luciano Coelho <luciano.coelho@nokia.com>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>> ---
>>  drivers/net/wireless/wl12xx/Kconfig |    6 +++++-
>>  1 files changed, 5 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/Kconfig b/drivers/net/wireless/wl12xx/Kconfig
>> index 1818e45..78029fd 100644
>> --- a/drivers/net/wireless/wl12xx/Kconfig
>> +++ b/drivers/net/wireless/wl12xx/Kconfig
>> @@ -1,10 +1,12 @@
>> -menuconfig WL12XX
>> +config WL12XX
>>        boolean "TI wl12xx driver support"
>>        depends on MAC80211 && EXPERIMENTAL
>>        ---help---
>>          This will enable TI wl12xx driver support. The drivers make
>>          use of the mac80211 stack.
>>
>> +if WL12XX
>> +
>>  config WL1251
>>        tristate "TI wl1251 support"
>>        depends on WL12XX && GENERIC_HARDIRQS
>
> If "if WL12XX", then no need to depend on WL12XX.

True!

  Luis
