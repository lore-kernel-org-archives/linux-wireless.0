Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:56882 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752240AbcICKDy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 3 Sep 2016 06:03:54 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath5k: fix EEPROM dumping via debugfs
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1470136768-28077-1-git-send-email-ryazanov.s.a@gmail.com>
To: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Nick Kossifidis <mickflemm@gmail.com>,
        "Luis R . Rodriguez" <mcgrof@do-not-panic.com>
Message-Id: <20160903100238.076E96201F@smtp.codeaurora.org> (sfid-20160903_120403_486074_44868DD4)
Date: Sat,  3 Sep 2016 10:02:38 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sergey Ryazanov <ryazanov.s.a@gmail.com> wrote:
> EEPROM size calculated in 16-bit words, so we should take into account
> this fact during buffer allocation.
> 
> CC: Jiri Slaby <jirislaby@gmail.com>
> CC: Nick Kossifidis <mickflemm@gmail.com>
> CC: Luis R. Rodriguez <mcgrof@do-not-panic.com>
> Signed-off-by: Sergey Ryazanov <ryazanov.s.a@gmail.com>

Thanks, 1 patch applied to wireless-drivers-next.git:

af8a9a67c346 ath5k: fix EEPROM dumping via debugfs

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9255675/
