Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:20289 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751736AbdJDIzw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Oct 2017 04:55:52 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: "silexcommon@gmail.com" <silexcommon@gmail.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Alagu Sankar <alagusankar@silex-india.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 01/11] ath10k_sdio: sdio htt data transfer fixes
Date: Wed, 4 Oct 2017 08:55:47 +0000
Message-ID: <878tgrxpf1.fsf@kamboji.qca.qualcomm.com> (sfid-20171004_105600_863209_7DBBA921)
References: <1506793068-27445-1-git-send-email-alagusankar@silex-india.com>
        <1506793068-27445-2-git-send-email-alagusankar@silex-india.com>
        <59D1EC94.2020307@broadcom.com>
In-Reply-To: <59D1EC94.2020307@broadcom.com> (Arend van Spriel's message of
        "Mon, 2 Oct 2017 09:36:52 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arend van Spriel <arend.vanspriel@broadcom.com> writes:

> On 9/30/2017 7:37 PM, silexcommon@gmail.com wrote:
>> From: Alagu Sankar <alagusankar@silex-india.com>
>>
>
> [...]
>
>>
>> Signed-off-by: Alagu Sankar <alagusankar@silex-india.com>
>
> Not really have a specific remark for this patch, but for the entire
> series. These patches are sent using an anonymous email address, apart
> from 'silex' being in there, which does not show up in the certificate
> of origin. Just wondering if this is acceptable?

As long as there's the "correct" From header as the first line in the
commit log, which git then uses as the author instead of the From line
from email header. And I see Alagu doing that here so there shouldn't be
any problems.

--=20
Kalle Valo=
