Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52210 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbeIDIv4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 04:51:56 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Subject: Re: [PATCH 1/3] debug: use common debug for ack timeout output
References: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
Date: Tue, 04 Sep 2018 07:28:37 +0300
In-Reply-To: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
        ("Tomislav \=\?utf-8\?Q\?Po\=C5\=BEega\=22's\?\= message of "Mon, 3 Sep 2018
 19:50:31 +0200")
Message-ID: <87tvn5sx6y.fsf@purkki.adurom.net> (sfid-20180904_062844_415696_DF0DB973)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:

> Move ack debug code to common-debug and adjust
> ath9k/ath9k_htc debug for common ack output.

Why? I guess to be able to get ack timeout with ath9k_htc, but please
write the reason clearly in the commit log.

Also the title prefix should be "ath9k:".

--=20
Kalle Valo
