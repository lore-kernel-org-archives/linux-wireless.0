Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59540 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752389AbdBJOZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 10 Feb 2017 09:25:10 -0500
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: "Valo, Kalle" <kvalo@qca.qualcomm.com>,
        Mohammed Shafi Shajakhan <mohammed@codeaurora.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] ath10k: Fix crash during rmmod when probe firmware
 fails
Date: Fri, 10 Feb 2017 12:16:42 +0000
Message-ID: <1486729001850.80243@qti.qualcomm.com> (sfid-20170210_152620_576603_A9C05DE2)
References: <1482221351-24029-1-git-send-email-mohammed@qca.qualcomm.com>
        <8760l38dz0.fsf@kamboji.qca.qualcomm.com>
        <871svr8d83.fsf@kamboji.qca.qualcomm.com>
        <20170206100448.GA13894@atheros-ThinkPad-T61>,<87lgteidii.fsf@kamboji.qca.qualcomm.com>
In-Reply-To: <87lgteidii.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi Shajakhan <mohammed@codeaurora.org> writes:=0A=
=0A=
> the change suggested by you helps, and the device probe, scan=0A=
> is successful as well. Still good to have this change part of your=0A=
> basic sanity and regression testing !=0A=
=0A=
Sure. I was sort of expecting that you would send v4 but I haven't seen=0A=
one so I guess you assumed I send that? :) I'll then submit v4.=0A=
=0A=
[shafi] thanks Kalle, just saw your patch.=0A=
=0A=
regards,=0A=
shafi=0A=
