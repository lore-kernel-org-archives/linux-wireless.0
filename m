Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54878 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752289AbcINHHR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:07:17 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: "bartosz.markowski@tieto.com" <bartosz.markowski@tieto.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH 2/2] ath10k: add platform regulatory domain support
Date: Wed, 14 Sep 2016 07:06:54 +0000
Message-ID: <871t0nhsdu.fsf@kamboji.qca.qualcomm.com> (sfid-20160914_090721_283220_F2FA5163)
References: <1470140454-3899-1-git-send-email-bartosz.markowski@tieto.com>
        <1470140454-3899-3-git-send-email-bartosz.markowski@tieto.com>
        <87bmztm8qm.fsf@kamboji.qca.qualcomm.com>
        <CACKGw+FAwPb2NLW5G8CnGH4X2eCCjUkuJwLoqW9w9rKpDuQJDw@mail.gmail.com>
In-Reply-To: <CACKGw+FAwPb2NLW5G8CnGH4X2eCCjUkuJwLoqW9w9rKpDuQJDw@mail.gmail.com>       (Bartosz
 Markowski's message of "Tue, 13 Sep 2016 15:57:17 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bartosz Markowski <bartosz.markowski@tieto.com> writes:

> On 12 September 2016 at 17:35, Valo, Kalle <kvalo@qca.qualcomm.com> wrote=
:
>
>> > +#ifdef CONFIG_ACPI
>> > +#define WRD_METHOD "WRDD"
>> > +#define WRDD_WIFI  (0x07)
>> > +
>> > +static u32 ath10k_mac_wrdd_get_mcc(struct ath10k *ar, union acpi_obje=
ct *wrdd)
>> > +{
>>
>> I don't think the ifdef is really necessary, acpi.h should handle that
>> (hopefully). Also I changed the error handling to use standard error
>> values and changed the info messages to dbg, they are too spammy in my
>> opinion. Please check carefully my changes in the pending branch:
>>
>> https://git.kernel.org/cgit/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3Dfe91745381ec3999d8de6dedb07b396c82539717
>
> I'm OK with the changes, I have not tried that though, except of
> reviewing and compiling it (do not have access to the chromebook for
> next few days). If you want to wait with it until I test it, it's fine
> too.

Ok, I'll wait for few days in case you have time to test it.

--=20
Kalle Valo=
