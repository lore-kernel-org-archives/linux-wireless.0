Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57472 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934419AbdCWPwC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Mar 2017 11:52:02 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v6 09/10] ath10k: different fw file names for usb and sdio
Date: Thu, 23 Mar 2017 15:51:58 +0000
Message-ID: <87mvccyorl.fsf@kamboji.qca.qualcomm.com> (sfid-20170323_165224_017494_E58BEFD3)
References: <148959263520.31432.8488419244476213373.stgit@potku.adurom.net>
        <148959280431.31432.16087997710973721077.stgit@potku.adurom.net>
        <e25f7672-0114-7928-7f4a-cf64638dc900@qca.qualcomm.com>
In-Reply-To: <e25f7672-0114-7928-7f4a-cf64638dc900@qca.qualcomm.com> (Ryan
        Hsu's message of "Thu, 16 Mar 2017 21:08:20 +0000")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> writes:

> On 03/15/2017 08:46 AM, Kalle Valo wrote:
>
>> From: Erik Stromdahl <erik.stromdahl@gmail.com>
>>
>> Since both SDIO and USB based chipsets will use different
>
> nitpick, since the patch is separating the USB and SDIO support now,
> maybe you want to remove the "USB" from the patch title?

Will fix in v7.

--=20
Kalle Valo=
