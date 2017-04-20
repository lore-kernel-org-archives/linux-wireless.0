Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:54758 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S944066AbdDTLA0 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Apr 2017 07:00:26 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [1/2] rt2800: fix LNA gain assignment for MT7620
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20170417193007.GA3436@makrotopia.org>
References: <20170417193007.GA3436@makrotopia.org>
To: Daniel Golle <daniel@makrotopia.org>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        linux-wireless@vger.kernel.org
Message-Id: <20170420110025.45AB5610D5@smtp.codeaurora.org> (sfid-20170420_130043_499867_41BBAA8C)
Date: Thu, 20 Apr 2017 11:00:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Golle <daniel@makrotopia.org> wrote:
> The base value used for MT7620 differs from Rt5392 which resulted in
> quite bad RX signal quality. Fix this by using the correct base value as
> well as the LNA calibration values for HT20.
> 
> Reported-by: Tom Psyborg <pozega.tomislav@gmail.com>
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

2 patches applied to wireless-drivers-next.git, thanks.

225a644aae03 rt2800: fix LNA gain assignment for MT7620
2031badabf26 rt2800: do VCO calibration after programming ALC

-- 
https://patchwork.kernel.org/patch/9684465/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
