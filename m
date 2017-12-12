Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:26528 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752373AbdLLMD1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 12 Dec 2017 07:03:27 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Loic Poulain <loic.poulain@linaro.org>
CC: "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "bjorn.andersson@linaro.org" <bjorn.andersson@linaro.org>,
        "wcn36xx@lists.infradead.org" <wcn36xx@lists.infradead.org>,
        "k.eugene.e@gmail.com" <k.eugene.e@gmail.com>
Subject: Re: [PATCH v2] wcn36xx: Fix dynamic power saving
Date: Tue, 12 Dec 2017 12:03:22 +0000
Message-ID: <87bmj4qhkm.fsf@kamboji.qca.qualcomm.com> (sfid-20171212_130332_738299_64FE34A0)
References: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1512982342-10343-1-git-send-email-loic.poulain@linaro.org> (Loic
        Poulain's message of "Mon, 11 Dec 2017 09:52:22 +0100")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Loic Poulain <loic.poulain@linaro.org> writes:

> Since driver does not report hardware dynamic power saving cap,
> this is up to the mac80211 to manage power saving timeout and
> state machine, using the ieee80211 config callback to report
> PS changes. This patch enables/disables PS mode according to
> the new configuration.
>
> Remove old behaviour enabling PS mode in a static way, this make
> the device unusable when power save is enabled since device is
> forced to PS regardless RX/TX traffic.
>
> Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Loic Poulain <loic.poulain@linaro.org>

A fixes line would be nice for backporters. I can add that but need the
commit id.

--=20
Kalle Valo=
