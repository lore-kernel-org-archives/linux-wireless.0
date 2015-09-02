Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f175.google.com ([209.85.160.175]:34574 "EHLO
	mail-yk0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853AbbIBLZG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Sep 2015 07:25:06 -0400
Received: by ykdg206 with SMTP id g206so5915078ykd.1
        for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2015 04:25:04 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CACKGw+FU0tQ4HZ0O=AB8uo-HyNshr0zjd-Hb+4NytpzsOH4TdQ@mail.gmail.com>
References: <1440679653-20289-1-git-send-email-michal.kazior@tieto.com>
	<CACKGw+FU0tQ4HZ0O=AB8uo-HyNshr0zjd-Hb+4NytpzsOH4TdQ@mail.gmail.com>
Date: Wed, 2 Sep 2015 13:25:04 +0200
Message-ID: <CACKGw+GQKt3frfGxU=M8XLg6adM5GVBasPd5OrwrGMaCvNsvzA@mail.gmail.com> (sfid-20150902_132512_951722_C50A9C94)
Subject: Re: [PATCH 1/2] ath10k: change beamformee VHT STS capability
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k <ath10k@lists.infradead.org>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 August 2015 at 14:56, Bartosz Markowski
<bartosz.markowski@tieto.com> wrote:
> On 27 August 2015 at 14:47, Michal Kazior <michal.kazior@tieto.com> wrote:
>> From: Bartosz Markowski <bartosz.markowski@tieto.com>
>>
>> All beamformee supporting chips have the ability to support
>> VHT NDP in up to 4 STSs. Change the published beamformee
>> STS cap accordingly to 3 as it should be Nsts-1.
>>
>> This makes it possible to actually make full use
>> of. e.g. a 4SS MU-MIMO capable AP.
>>
>> Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
>
> Kalle, please drop this one for now. It looks like we need to discuss
> about this a bit more still.

I have sent a follow up on this, splitting it into 2 patches (vht nsts
and sounding dimensions), addressing the concerns raised about the
lack of firmware passing the needed bits in vht_cap_info.

Bartosz
