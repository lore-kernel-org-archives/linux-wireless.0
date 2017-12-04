Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sonic306-34.consmr.mail.ir2.yahoo.com ([77.238.176.220]:46644
        "EHLO sonic306-34.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752216AbdLDUnz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 15:43:55 -0500
Date: Mon, 4 Dec 2017 20:43:50 +0000 (UTC)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To: <linux-wireless@vger.kernel.org>,
        Gabriele Gristina <gabriele.gristina@gmail.com>
Cc: Herton Ronaldo Krzesinski <herton@canonical.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <831356585.2629841.1512420230218@mail.yahoo.com> (sfid-20171204_214358_720899_6CA6062A)
Subject: Re: [PATCH] rtl8187: add master mode
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <831356585.2629841.1512420230218.ref@mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--------------------------------------------
On Mon, 4/12/17, Gabriele Gristina <gabriele.gristina@gmail.com> wrote:

> This patch add the master mode to rtl8187
> wireless driver.
 
> Signed-off-by: Gabriele Gristina <gabriele.gristina@gmail.com>

Your two-line patch is most likely completely wrong... master mode is not just the driver claiming (and lying...) to support master mode. At least, it is extremely imcomplete.

We discussed this briefly some years ago; my impression of the discussion was that devices supporting master modes need to have some specific features which are not found in low-end devices (rtl818x being such). Although some of these necessities were foresaw to be possible to be implemented in software (i.e. the rest of the kernel in the core wifi stack) in a later stage.

I think Larry can say a bit more in this matter.

Hin-Tak
