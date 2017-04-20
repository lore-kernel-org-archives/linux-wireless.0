Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35800 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940478AbdDTIwE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 04:52:04 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qti.qualcomm.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: ath10k: ath10k: bump up FW API to 6
Date: Thu, 20 Apr 2017 08:52:00 +0000
Message-ID: <87fuh35umo.fsf@kamboji.qca.qualcomm.com> (sfid-20170420_105209_320776_D361E75F)
References: <1491944688-5795-1-git-send-email-ryanhsu@qca.qualcomm.com>
        <8a9bab5f36e8456bafa8d872012bcf3a@euamsexm01a.eu.qualcomm.com>
In-Reply-To: <8a9bab5f36e8456bafa8d872012bcf3a@euamsexm01a.eu.qualcomm.com>
        (Kalle Valo's message of "Wed, 19 Apr 2017 16:07:07 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> ryanhsu@qti.qualcomm.com wrote:
>> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
>>=20
>> For QCA6174 hw3.0, since WLAN.RM.4.4-00022-QCARMSWPZ-2, it starts to
>> support the board ID information from otp, with some devices released on
>> the market that didn't calibrated with OTP, will have 0 for board ID
>> information, which cause the backward compatibility issue and was fixed
>> in commit 'd2e202c06ca4 ("ath10k: ignore configuring the incorrect board=
_id")'
>>=20
>> So bump the fw api version to differentiate the latest firmware support.
>>=20
>> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>
>
> Patch applied to ath-next branch of ath.git, thanks.
>
> aad1fd7f7677 ath10k: bump up FW API to 6

And I renamed the RM.4.4 firmware image also:

https://github.com/kvalo/ath10k-firmware/commit/da1564dafe1c8175faf694482d1=
649f56229ae96

--=20
Kalle Valo=
