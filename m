Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39792 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0EZSHw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 May 2010 14:07:52 -0400
Received: by gyg13 with SMTP id 13so3150834gyg.19
        for <linux-wireless@vger.kernel.org>; Wed, 26 May 2010 11:07:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTinAgV0Vd4mjuVB_wOARcWlAC_VKAoEmCS0rr1qa@mail.gmail.com>
References: <-4856622450948873340@unknownmsgid>
	<AANLkTinAgV0Vd4mjuVB_wOARcWlAC_VKAoEmCS0rr1qa@mail.gmail.com>
Date: Wed, 26 May 2010 13:07:49 -0500
Message-ID: <AANLkTiklOsGCeh26tiIgE6xMvvwSrpezhYe4HC-lfKnw@mail.gmail.com>
Subject: Re: [ath9k-devel] ath9k: 802.11n ad-hoc mode and mesh mode
From: Xianghua Xiao <xiaoxianghua@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: =?UTF-8?B?SsOzbmF0YW4gTXXDsW96?= <jonatan.munoz@alu.umh.es>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

the non-HT 80211n mesh should work, however for 80211N I think HT is
not fully supported(yet) for mesh.

Xianghua

On Wed, May 26, 2010 at 11:53 AM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Wed, May 26, 2010 at 2:33 AM, Jónatan Muñoz <jonatan.munoz@alu.umh.es> wrote:
>>
>>
>>
>>
>> Hi All,
>>
>>
>>
>> I’m interested in ad-hoc and mesh networks and I have some questions.
>>
>>
>>
>> Does anyone know if mesh mode is successfully enabled for AR9280?
>
> Yes, does no one read the documentation or think of looking for it?
>
> http://wireless.kernel.org/en/users/Drivers
> http://wireless.kernel.org/en/users/Drivers/ath9k#supported_chipsets
>
>  Luis
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
