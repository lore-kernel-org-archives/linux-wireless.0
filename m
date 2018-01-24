Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43886 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933953AbeAXPoU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Jan 2018 10:44:20 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Pkshih <pkshih@realtek.com>
Cc: "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/10] rtlwifi: Add spec_ver to check whether use new rate-id or not
References: <20180119064551.10084-1-pkshih@realtek.com>
        <20180119064551.10084-11-pkshih@realtek.com>
        <a213209f-e597-d700-6c8b-cadb35af63cc@lwfinger.net>
        <1516668104.2764.1.camel@realtek.com>
Date: Wed, 24 Jan 2018 17:44:16 +0200
In-Reply-To: <1516668104.2764.1.camel@realtek.com> (pkshih@realtek.com's
        message of "Tue, 23 Jan 2018 00:41:44 +0000")
Message-ID: <87a7x3tg6n.fsf@purkki.adurom.net> (sfid-20180124_164459_822970_E8852B9B)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pkshih <pkshih@realtek.com> writes:

> On Mon, 2018-01-22 at 13:10 -0600, Larry Finger wrote:
>> On 01/19/2018 12:45 AM, pkshih@realtek.com wrote:
>> >=C2=A0
>> > From: Ping-Ke Shih <pkshih@realtek.com>
>> >=C2=A0
>> > The field spec_ver is IC's specification mask for common code to do pr=
oper
>> > process to specified IC. This commit add a field new rate ID for new
>> > generation IC.
>> >=C2=A0
>> > Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
>> Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>>=C2=A0
>
> Shall I append "Acked-by" in v2?

Yes, you can add Acked-by in the next version (if the patch in question
is not modified after the ack).

But do note that patchwork can automatically take Acked-by from the
mailing list, for example that happened in the 9 patches I just applied
from this series. So you no need to resend the rtlwifi patches for just
to add the Acked-by line.

--=20
Kalle Valo
