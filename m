Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53298 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbeIDIyw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Sep 2018 04:54:52 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Tomislav =?utf-8?Q?Po=C5=BEega?= <pozega.tomislav@gmail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        ath9k_htc_fw@lists.infradead.org
Subject: Re: [PATCH 3/3] ath9k_htc: increase number of configurable virtual interfaces
References: <1535997033-16330-1-git-send-email-pozega.tomislav@gmail.com>
        <1535997033-16330-3-git-send-email-pozega.tomislav@gmail.com>
Date: Tue, 04 Sep 2018 07:31:33 +0300
In-Reply-To: <1535997033-16330-3-git-send-email-pozega.tomislav@gmail.com>
        ("Tomislav \=\?utf-8\?Q\?Po\=C5\=BEega\=22's\?\= message of "Mon, 3 Sep 2018
 19:50:33 +0200")
Message-ID: <87pnxtsx22.fsf@purkki.adurom.net> (sfid-20180904_063139_375306_99B21F61)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Tomislav Po=C5=BEega <pozega.tomislav@gmail.com> writes:

> Increase driver limit for various interface combinations.
> I was able to start 8 virtual APs and connect 5 clients to
> these. Frimware support is required too, see:
> https://github.com/qca/open-ath9k-htc-firmware/pull/149

So what is the exact firmware version which has this support? Is it
available from linux-firmware.git?

And what about people using older firmware? Now it's easy to use a
unsupported configuration with those firmware images. The best would be
that ath9k could somehow detect what features the firmware supports.

--=20
Kalle Valo
