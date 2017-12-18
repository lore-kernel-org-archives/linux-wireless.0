Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:36322 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750830AbdLRNjs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Dec 2017 08:39:48 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wright Feng <wright.feng@cypress.com>
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, chi-hsien.lin@cypress.com,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        Double Lo <double.lo@cypress.com>
Subject: Re: brcmfmac: Support 43455 save-restore (SR) feature if FW include -sr
References: <1512639183-3357-1-git-send-email-wright.feng@cypress.com>
        <20171214123944.12BEB6020A@smtp.codeaurora.org>
        <96068b8b-2ce9-8a82-122a-0cfafce1cd98@cypress.com>
Date: Mon, 18 Dec 2017 15:39:42 +0200
In-Reply-To: <96068b8b-2ce9-8a82-122a-0cfafce1cd98@cypress.com> (Wright Feng's
        message of "Mon, 18 Dec 2017 10:03:56 +0800")
Message-ID: <87h8sokvdt.fsf@kamboji.qca.qualcomm.com> (sfid-20171218_143952_877177_F2515E64)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wright Feng <wright.feng@cypress.com> writes:

> On 2017/12/14 =E4=B8=8B=E5=8D=88 08:39, Kalle Valo wrote:
>> Wright Feng <wright.feng@cypress.com> wrote:
>>
>>> From: Double Lo <double.lo@cypress.com>
>>>
>>> This patch will add 43455 into the save-restore(SR) capable chip list, =
so
>>> the SR engine will be enabled with 43455 FW which built-in the -sr
>>> function.
>>>
>>> Signed-off-by: Double Lo <double.lo@cypress.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
>>
>> Wright's s-o-b is missing:
>>
>> https://wireless.wiki.kernel.org/en/developers/documentation/submittingp=
atches#signed-off-by_missing
>>
> Kalle,
> Thanks for reminding, please let me know if I have to send [Patch v2]
> for this.

Yes, please send v2.

To save my time you can actually check this from patchwork:

https://patchwork.kernel.org/patch/10097897/

If the state is "Changes Requested" it means that I'm expecting the
author to submit a new version. More info:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes#checking_state_of_patches_from_patchwork

--=20
Kalle Valo
