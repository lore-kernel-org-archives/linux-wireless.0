Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52440 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbeAWH4g (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 02:56:36 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 0/4] ath9k: AR9003 noise floor calibration support
References: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Tue, 23 Jan 2018 09:56:31 +0200
In-Reply-To: <1516692925-6695-1-git-send-email-Wojciech.Dubowik@neratec.com>
        (Wojciech Dubowik's message of "Tue, 23 Jan 2018 08:35:21 +0100")
Message-ID: <87o9ll57ps.fsf@kamboji.qca.qualcomm.com> (sfid-20180123_085640_569041_D1A1EC57)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> AR9003 series allows to calibrate noise floor for different frequency
> bins. Once it's done it's possible to get more accurate rssi/signal
> values over whole frequency band at a given temperature.
> The RSSI/signal accuracy reported by calibrated RF cards improves
> from 6 to up to 2dB.
>
> This could be interesting for application which require good signal
> accuracy like roaming or mesh protocols.

This is a very good description of the feature. I think you should copy
it to the patch 3 commit log so that it gets archived to git. (I don't
store cover letters to git.)

-- 
Kalle Valo
