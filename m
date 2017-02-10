Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36297 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752558AbdBJLh2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 06:37:28 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware
 fails
Date: Fri, 10 Feb 2017 11:36:04 +0000
Message-ID: <874m02i8hj.fsf@kamboji.qca.qualcomm.com> (sfid-20170210_123735_565093_2F8F7B7B)
References: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
        <8760l38dz0.fsf@kamboji.qca.qualcomm.com>
        <871svr8d83.fsf@kamboji.qca.qualcomm.com>
        <20170206100448.GA13894@atheros-ThinkPad-T61>
        <87lgteidii.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lgteidii.fsf@kamboji.qca.qualcomm.com> (Kalle Valo's message
        of "Fri, 10 Feb 2017 11:47:01 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> BTW, just curious but why do you have "during rmmod" in the title? I
> think I was able to reproduce this crash by removing all firmware files
> and didn't use rmmod at all.

Nevermind, I was blind again. It was my script which calls rmmod and I
failed to realise that. Sorry for the noise.

--=20
Kalle Valo=
