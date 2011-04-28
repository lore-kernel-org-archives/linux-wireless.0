Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34875 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756008Ab1D1SNM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 14:13:12 -0400
Received: by iyb14 with SMTP id 14so2441033iyb.19
        for <linux-wireless@vger.kernel.org>; Thu, 28 Apr 2011 11:13:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com>
References: <1304000579-5784-1-git-send-email-mshajakhan@atheros.com> <BANLkTi=8Vc5MGjK=K3=hkFLy=kiFy1osCg@mail.gmail.com>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 28 Apr 2011 11:12:51 -0700
Message-ID: <BANLkTinFYwvWSWreUd66DGdsdyo2uU53Hw@mail.gmail.com> (sfid-20110428_201317_888854_7F22622C)
Subject: Re: [RFC/RFT 0/9] ath9k: Add Antenna diversity support for AR9485
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Senthilkumar.Balasubramanian@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 28, 2011 at 11:12 AM, Luis R. Rodriguez
<lrodriguez@atheros.com> wrote:
> On Thu, Apr 28, 2011 at 7:22 AM, Mohammed Shafi Shajakhan
> <mshajakhan@atheros.com> wrote:
>> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
>>
>> *These are purely RFC/RFT patches, none of them are tested.
>>  once tested we will send it as patches.
>> *This patch set adds Antenna diversity support for AR9485, previously
>>  antenna diversity is only supported in AR9285
>> *The basic antenna diversity algorithm remains the same
>> *slight change in the diversity field in eeprom
>> *introduction of main/alt gain table and lna1_lna2 delta fields
>> *initially set LNA1 for main antenna
>> *introduction of diversity group
>> *based on diversity group, fast diversity bias parmaters and
>> lna1_lna2_delta varies
>> *implement an API to take the decision of swapping main/ALT LNA's
>> for AR9485
>> *configure fast diversity bias based on diversity group
>
> Apart from my one comment:
>
> Reviewed-by: Luis R. Rodriguez <lrodriguez@atheros.com>

Oh yeah and great job on your patch split!

  Luis
