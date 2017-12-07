Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:3932 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753762AbdLGOaV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 09:30:21 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Jakub Kicinski <kubakici@wp.pl>
CC: Matthias Schiffer <mschiffer@universe-factory.net>,
        ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: [PATCH 1/3] ath9k: remove stray backslash in Makefile
Date: Thu, 7 Dec 2017 14:30:14 +0000
Message-ID: <87374mvcej.fsf@kamboji.qca.qualcomm.com> (sfid-20171207_153243_058284_E320D62C)
References: <e60138924429ca428efc6e3154606887b3bc5201.1511804622.git.mschiffer@universe-factory.net>
        <20171127193516.682827ea@cakuba.netronome.com>
In-Reply-To: <20171127193516.682827ea@cakuba.netronome.com> (Jakub Kicinski's
        message of "Mon, 27 Nov 2017 19:35:16 -0800")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jakub Kicinski <kubakici@wp.pl> writes:

> On Mon, 27 Nov 2017 18:56:21 +0100, Matthias Schiffer wrote:
>> Signed-off-by: Matthias Schiffer <mschiffer@universe-factory.net>
>> ---
>>  drivers/net/wireless/ath/ath9k/Makefile | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/net/wireless/ath/ath9k/Makefile b/drivers/net/wirel=
ess/ath/ath9k/Makefile
>> index 36a40ffdce15..90e4a341076c 100644
>> --- a/drivers/net/wireless/ath/ath9k/Makefile
>> +++ b/drivers/net/wireless/ath/ath9k/Makefile
>> @@ -59,7 +59,7 @@ obj-$(CONFIG_ATH9K_HW) +=3D ath9k_hw.o
>>  obj-$(CONFIG_ATH9K_COMMON) +=3D ath9k_common.o
>>  ath9k_common-y:=3D	common.o \
>>  			common-init.o \
>> -			common-beacon.o \
>> +			common-beacon.o
>> =20
>
> It's not necessarily stray, there is nothing on the next line so it's
> OK, and if you add \ at the end of all lines, you don't have to touch
> the last line every time you add/remove something.  Sort of like
> putting a , after last enum value.

I agree with Jakub, I think the backslash is there on purpose so I
dropped this patch.

--=20
Kalle Valo=
