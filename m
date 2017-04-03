Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750777AbdDCJee (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Apr 2017 05:34:34 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Johan Hovold <johan@kernel.org>
Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sujith Manoharan <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 1/2] wireless: ath9k_htc: fix NULL-deref at probe
References: <20170313124421.28587-1-johan@kernel.org>
        <20170403084213.GE25742@localhost>
Date: Mon, 03 Apr 2017 12:34:26 +0300
In-Reply-To: <20170403084213.GE25742@localhost> (Johan Hovold's message of
        "Mon, 3 Apr 2017 10:42:13 +0200")
Message-ID: <87shlpomvx.fsf@kamboji.qca.qualcomm.com> (sfid-20170403_113512_146028_024AEEC3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johan Hovold <johan@kernel.org> writes:

> On Mon, Mar 13, 2017 at 01:44:20PM +0100, Johan Hovold wrote:
>> Make sure to check the number of endpoints to avoid dereferencing a
>> NULL-pointer or accessing memory beyond the endpoint array should a
>> malicious device lack the expected endpoints.
>> 
>> Fixes: 36bcce430657 ("ath9k_htc: Handle storage devices")
>> Cc: Sujith Manoharan <Sujith.Manoharan@atheros.com>
>> Signed-off-by: Johan Hovold <johan@kernel.org>
>
> Is this one still in your queue, Kalle?

Yes, I'm just lacking behing:

https://patchwork.kernel.org/patch/9620723/

> As I mentioned earlier, I should have added a
>
> Cc: stable <stable@vger.kernel.org>     # 2.6.39
>
> but left it out as I mistakingly thought the net recommendations to do
> so applied also to wireless.

Ok, I'll add that.

-- 
Kalle Valo
