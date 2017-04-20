Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753646AbdDTHU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 03:20:27 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-19-2
References: <1492664371.31741.91.camel@coelho.fi>
        <1492664686.31741.93.camel@coelho.fi>
        <8760hz7el9.fsf@kamboji.qca.qualcomm.com>
        <1492672317.31741.109.camel@coelho.fi>
Date: Thu, 20 Apr 2017 10:20:04 +0300
In-Reply-To: <1492672317.31741.109.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 20 Apr 2017 10:11:57 +0300")
Message-ID: <871ssn7dgb.fsf@kamboji.qca.qualcomm.com> (sfid-20170420_092152_812503_F4BB61BB)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Thu, 2017-04-20 at 09:55 +0300, Kalle Valo wrote:
>> Luca Coelho <luca@coelho.fi> writes:
>> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
>> > b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
>> > index 6d745c36f1d8..097cb45c8ad9 100644
>> > --- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
>> > +++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
>> > @@ -55,7 +55,7 @@
>> > =C2=A0#include "iwl-agn-hw.h"
>> > =C2=A0
>> > =C2=A0/* Highest firmware API version supported */
>> > -#define IWL_A000_UCODE_API_MAX 31
>> > +#define IWL_A000_UCODE_API_MAX 30
>>=20
>> Good that you dropped this. I was a bit worried that if it the API bump
>> was too soon and inconvenient for the users.
>
> Yes, we usually bump it up internally *before* we get all the actual API
> changes in the firmware, so both the driver and the FW evolve together.
>
> So, in practice, I should bump the API to 30 upstream when we reach the
> bump to 31 internally (which means 30 is frozen at that point).

Sorry, I got confused. I guess I haven't even still properly woken up. I
was thinking the MIN API level and worried about forcing users to update
the firmware image too early.

--=20
Kalle Valo
