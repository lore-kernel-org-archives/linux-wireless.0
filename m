Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57888 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933729AbeBLM4A (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 12 Feb 2018 07:56:00 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH v2 00/10] rtlwifi: add more materials for 8822be
References: <20180129032641.17841-1-pkshih@realtek.com>
        <1518183733.2023.3.camel@realtek.com>
Date: Mon, 12 Feb 2018 14:55:55 +0200
In-Reply-To: <1518183733.2023.3.camel@realtek.com> (pkshih@realtek.com's
        message of "Fri, 9 Feb 2018 13:42:14 +0000")
Message-ID: <87wozi8izo.fsf@kamboji.qca.qualcomm.com> (sfid-20180212_135611_566906_744196B7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Mon, 2018-01-29 at 11:26 +0800, pkshih@realtek.com wrote:
>> From: Ping-Ke Shih <pkshih@realtek.com>
>>=20
>> I continue to submit more materials needed by 8822be. A special patch is
>> "PATCH 10/10" that add new files to support 8822be btcoex in case wifi
>> only. In my plan, 8822be btcoex for combo card will be sumitted in next
>> patchset.
>>=20
>> v2: Add 'Acked-by: Larry Finger' if the commits are acked
>> =C2=A0=C2=A0=C2=A0=C2=A0Use 'switch...case' to replace verbose 'if...els=
e if...else if...else'
>> =C2=A0=C2=A0=C2=A0=C2=A0Use extern declaration to quiet sparse warnings
>>=20
>> Ping-Ke Shih (10):
>> =C2=A0 rtlwifi: enable mac80211 fast-tx support
>> =C2=A0 rtlwifi: Add Support VHT to spec_ver
>> =C2=A0 rtlwifi: Use 6 bits as sequence number of TX report
>> =C2=A0 rtlwifi: Extend tx_power_by_rate_offset size for newer IC
>> =C2=A0 rtlwifi: Add rate section and its related definition and comment
>> =C2=A0 rtlwifi: Fix VHT NSS in RC
>> =C2=A0 rtlwifi: add definition radio_mask for RF and maximum bandwidth
>> =C2=A0 rtlwifi: add efuse ops for other components
>> =C2=A0 rtlwifi: btcoex: add routine to set default port id
>> =C2=A0 rtlwifi: btcoex: Add 8822be btcoex supported files for wifi only

[...]

> Do you have any comment with this patchset that is pending for 2 weeks?

Normally I don't review or apply patches during when the merge window is
open, only exception being important fixes going to wireless-drivers
tree.

Also read this: https://wireless.wiki.kernel.org/en/developers/documentatio=
n/submittingpatches#checking_state_of_patches_from_patchwork

--=20
Kalle Valo
