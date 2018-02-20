Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60484 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751038AbeBTOqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:46:07 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: Re: [PATCH 2/2] ath9k: Fix ack SIFS time for quarter/half channels
References: <1519137720-9129-1-git-send-email-Wojciech.Dubowik@neratec.com>
Date: Tue, 20 Feb 2018 16:46:00 +0200
In-Reply-To: <1519137720-9129-1-git-send-email-Wojciech.Dubowik@neratec.com>
        (Wojciech Dubowik's message of "Tue, 20 Feb 2018 15:42:00 +0100")
Message-ID: <87h8qb3ejb.fsf@kamboji.qca.qualcomm.com> (sfid-20180220_154610_695133_04D17049)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wojciech Dubowik <Wojciech.Dubowik@neratec.com> writes:

> Ack timing generation has to be adapted for 5/10 MHz channels.
> Do it by properly initializing ack shift field in TXSIFS
> register. Ack shift assumes channel width of 2.5 Hhz so

Is this supposed to be MHz? I can fix that during commit, no need to
resend just because of this.

-- 
Kalle Valo
