Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57368 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753863AbeBZO6i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 09:58:38 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Cc: "linux-firmware\@kernel.org" <linux-firmware@kernel.org>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PULL] ath10k firmware 20180219
References: <87y3jlxq0k.fsf@kamboji.qca.qualcomm.com>
        <0e9db63d-41e9-eeb3-00d1-73b20df4bb3f@dd-wrt.com>
Date: Mon, 26 Feb 2018 16:58:33 +0200
In-Reply-To: <0e9db63d-41e9-eeb3-00d1-73b20df4bb3f@dd-wrt.com> (Sebastian
        Gottschall's message of "Thu, 22 Feb 2018 11:59:02 +0100")
Message-ID: <87606ju7ae.fsf@kamboji.qca.qualcomm.com> (sfid-20180226_155842_277334_A64CF11D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastian Gottschall <s.gottschall@dd-wrt.com> writes:

> on 9984 i see these messages with this firmware from time to time
>
> [272972.950788] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [272982.868922] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [335550.123780] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [335550.156332] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [335550.158813] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [335550.193144] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [365157.869540] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
> [365157.902452] ath10k_pci 0000:01:00.0: Unknown eventid: 36925
>
>
> according to the WMI header this maybe a critical internal error

Thanks for the report. We are working on a fix but just ignore the
warning for now.

-- 
Kalle Valo
