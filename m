Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:51212 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934972AbeFMKAg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jun 2018 06:00:36 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Timur =?utf-8?Q?Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: Ryan Hsu <ryanhsu@codeaurora.org>, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath10k: Update the phymode along with bandwidth change request
References: <1528482759-12604-1-git-send-email-ryanhsu@codeaurora.org>
        <944989ec907b98716f252524cf55e41807965253.camel@gmail.com>
        <87muw0cjwq.fsf@kamboji.qca.qualcomm.com>
        <411d1d752811ce2b701d9f3a0d20f05050dc2e09.camel@gmail.com>
Date: Wed, 13 Jun 2018 13:00:32 +0300
In-Reply-To: <411d1d752811ce2b701d9f3a0d20f05050dc2e09.camel@gmail.com>
        ("Timur \=\?utf-8\?Q\?Krist\=C3\=B3f\=22's\?\= message of "Tue, 12 Jun 2018 14:21:20
 +0200")
Message-ID: <878t7jatvj.fsf@kamboji.qca.qualcomm.com> (sfid-20180613_120040_680871_95CDDBAE)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Timur Krist=C3=B3f <timur.kristof@gmail.com> writes:

>> > Can it be accepted, or is there anything I can help with, to get it
>> > accepted?
>>=20
>> Strangely I can't find Timur's version of the patch from patchwork:
>>=20
>> https://patchwork.kernel.org/project/linux-wireless/list/?state=3D*
>>=20
>> Maybe it got dropped due to some UTF-8 problems? patchwork is known
>> to
>> be problematic with UTF-8.
>
> Not sure. It doesn't really matter now, Ryan's version is fine too.

Sure but try to remember this if you are planning to submit more
wireless patches in the future. Johannes and me take patches directly
from patchwork, and if the patch isn't there we won't see it.

--=20
Kalle Valo
