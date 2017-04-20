Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36820 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S968205AbdDTGzg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 02:55:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Luca Coelho <luca@coelho.fi>
Cc: linux-wireless@vger.kernel.org, linuxwifi <linuxwifi@intel.com>
Subject: Re: pull-request: iwlwifi-next 2017-04-19-2
References: <1492664371.31741.91.camel@coelho.fi>
        <1492664686.31741.93.camel@coelho.fi>
Date: Thu, 20 Apr 2017 09:55:30 +0300
In-Reply-To: <1492664686.31741.93.camel@coelho.fi> (Luca Coelho's message of
        "Thu, 20 Apr 2017 08:04:46 +0300")
Message-ID: <8760hz7el9.fsf@kamboji.qca.qualcomm.com> (sfid-20170420_085604_341679_DF4330C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca Coelho <luca@coelho.fi> writes:

> On Thu, 2017-04-20 at 07:59 +0300, Luca Coelho wrote:
>> Here's v2 of=C2=A0my second pull-request intended for v4.12.  It include=
s the
>> last three patch series I sent out, namely 2017-04-13, 2017-04-19 and
>> the 2 fixes by Johannes that I sent a few minutes ago.
>>=20
>> I also removed the "bump API to 31" patch.  I'll send a diff=C2=A0between
>> this tag and the HEAD of the patches I sent in the 2017-04-19 series.
>
> This is the diffenrece between my pending branch (which contains all the
> patches up to 2017-04-19) and this pull-request.  For the record of what
> I had to change.
>
>
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
> index 904e17956e2c..b9718c0cf174 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
> @@ -70,8 +70,8 @@
> =C2=A0#include "iwl-agn-hw.h"
> =C2=A0
> =C2=A0/* Highest firmware API version supported */
> -#define IWL8000_UCODE_API_MAX=C2=A0=C2=A031
> -#define IWL8265_UCODE_API_MAX=C2=A0=C2=A031
> +#define IWL8000_UCODE_API_MAX=C2=A0=C2=A030
> +#define IWL8265_UCODE_API_MAX=C2=A0=C2=A030
> =C2=A0
> =C2=A0/* Lowest firmware API version supported */
> =C2=A0#define IWL8000_UCODE_API_MIN=C2=A0=C2=A017
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
> index 42a6e723191e..110ceefccc15 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
> @@ -55,7 +55,7 @@
> =C2=A0#include "iwl-agn-hw.h"
> =C2=A0
> =C2=A0/* Highest firmware API version supported */
> -#define IWL9000_UCODE_API_MAX=C2=A0=C2=A031
> +#define IWL9000_UCODE_API_MAX=C2=A0=C2=A030
> =C2=A0
> =C2=A0/* Lowest firmware API version supported */
> =C2=A0#define IWL9000_UCODE_API_MIN=C2=A0=C2=A030
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> index 6d745c36f1d8..097cb45c8ad9 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
> @@ -55,7 +55,7 @@
> =C2=A0#include "iwl-agn-hw.h"
> =C2=A0
> =C2=A0/* Highest firmware API version supported */
> -#define IWL_A000_UCODE_API_MAX 31
> +#define IWL_A000_UCODE_API_MAX 30

Good that you dropped this. I was a bit worried that if it the API bump
was too soon and inconvenient for the users.

--=20
Kalle Valo
