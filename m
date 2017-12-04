Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sonic304-37.consmr.mail.ir2.yahoo.com ([77.238.179.162]:46450
        "EHLO sonic304-37.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751718AbdLDW6C (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Dec 2017 17:58:02 -0500
Date: Mon, 4 Dec 2017 22:57:55 +0000 (UTC)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: Hin-Tak Leung <htl10@users.sourceforge.net>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Kalle Valo <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        Colin King <colin.king@canonical.com>
Cc: <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <734417985.2789125.1512428275673@mail.yahoo.com> (sfid-20171204_235835_066209_C788887B)
Subject: Re: [PATCH] rtlwifi: rtl818x: remove redundant check for cck_power
 > 15
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <734417985.2789125.1512428275673.ref@mail.yahoo.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--------------------------------------------
On Tue, 14/11/17, Colin King <colin.king@canonical.com> wrote:

=20
> From: Colin Ian King <colin.king@canonical.com>
=20
> cck_poweri cannot be greated than 15 as
> is derived from the bottom 4 bits
> from riv->channels[channel -
> 1].hw_value & 0xf.=C2=A0 Hence the check for it
> being greater than 15 is redundant and
> can be removed.
=20
> Detected by CoverityScan, CID#744303
> ("Logically dead code")
=20
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
=20
Acked-by: Hin-Tak Leung <htl10@users.sourceforge.net>
