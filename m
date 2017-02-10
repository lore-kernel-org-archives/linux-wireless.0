Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:4168 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751324AbdBJJsA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 04:48:00 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware
 fails
Date: Fri, 10 Feb 2017 09:47:28 +0000
Message-ID: <87lgteidii.fsf@kamboji.qca.qualcomm.com> (sfid-20170210_104809_460087_3C0A2B1A)
References: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
        <8760l38dz0.fsf@kamboji.qca.qualcomm.com>
        <871svr8d83.fsf@kamboji.qca.qualcomm.com>
        <20170206100448.GA13894@atheros-ThinkPad-T61>
In-Reply-To: <20170206100448.GA13894@atheros-ThinkPad-T61> (Mohammed Shafi
        Shajakhan's message of "Mon, 6 Feb 2017 15:34:48 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:

> the change suggested by you helps, and the device probe, scan
> is successful as well. Still good to have this change part of your
> basic sanity and regression testing !

Sure. I was sort of expecting that you would send v4 but I haven't seen
one so I guess you assumed I send that? :) I'll then submit v4.

BTW, just curious but why do you have "during rmmod" in the title? I
think I was able to reproduce this crash by removing all firmware files
and didn't use rmmod at all.

--=20
Kalle Valo=
