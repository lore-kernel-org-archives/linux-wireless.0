Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30656 "EHLO
        sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754062AbdLGPI2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Dec 2017 10:08:28 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rakesh Pillai <pillair@qti.qualcomm.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Govind Singh <govinds@qti.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] ath10k: WMI: add hw params entry for wcn3990
Date: Thu, 7 Dec 2017 15:08:22 +0000
Message-ID: <87po7qtw2j.fsf@kamboji.qca.qualcomm.com> (sfid-20171207_160833_661322_CA465222)
References: <1512214248-17127-1-git-send-email-pillair@qti.qualcomm.com>
        <1512214248-17127-5-git-send-email-pillair@qti.qualcomm.com>
In-Reply-To: <1512214248-17127-5-git-send-email-pillair@qti.qualcomm.com>
        (Rakesh Pillai's message of "Sat, 2 Dec 2017 17:00:48 +0530")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rakesh Pillai <pillair@qti.qualcomm.com> writes:

> Add hw params entry for wcn3990 and populate various
> target specific values for wcn3990.
>
> Signed-off-by: Rakesh Pillai <pillair@qti.qualcomm.com>
> Signed-off-by: Govind Singh <govinds@qti.qualcomm.com>

New warning:

drivers/net/wireless/ath/ath10k/hw.c:935:43: warning: Using plain integer a=
s NULL pointer

--=20
Kalle Valo=
