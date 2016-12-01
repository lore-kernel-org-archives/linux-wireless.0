Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58577 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756421AbcLAKe5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 05:34:57 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
Subject: Re: ath10k: Fix soft lockup during firmware crash/hw-restart
Date: Thu, 1 Dec 2016 10:34:50 +0000
Message-ID: <87mvggrl87.fsf@kamboji.qca.qualcomm.com> (sfid-20161201_113513_521162_4E3D8077)
References: <1480430762-15995-1-git-send-email-mohammed@qca.qualcomm.com>
        <1a44a3e9-3d67-30a5-0325-a65003ebe1fc@candelatech.com>
        <20161201060612.GA8611@atheros-ThinkPad-T61>
In-Reply-To: <20161201060612.GA8611@atheros-ThinkPad-T61> (Mohammed Shafi
        Shajakhan's message of "Thu, 1 Dec 2016 11:36:31 +0530")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

> On Tue, Nov 29, 2016 at 10:16:50AM -0800, Ben Greear wrote:
>> Is this something for stable?  And if so, how far back should it be appl=
ied?
>
> @Kalle,
>
> [shafi] kindly suggest. If i am not wrong this is only needed for 4.9

Correct, commit 3c97f5de1f28 went to 4.9-rc1, it was not in 4.8. I'll
add CC stable to the commit log.

--=20
Kalle Valo=
