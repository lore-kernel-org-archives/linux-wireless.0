Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:58280 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbdFUQok (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Jun 2017 12:44:40 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/6] rsi: add usb RS9113 chipset support
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1497623741-2082-2-git-send-email-amit.karwar@redpinesignals.com>
References: <1497623741-2082-2-git-send-email-amit.karwar@redpinesignals.com>
To: amit karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Message-Id: <20170621152701.45D1C607E2@smtp.codeaurora.org> (sfid-20170621_184447_230060_308BF4B7)
Date: Wed, 21 Jun 2017 15:27:01 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

amit karwar <amitkarwar@gmail.com> wrote:

> From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> 
> usb device id and vendor id for RS9113 chipset are included.
> So it can be used through usb interface.
> 
> Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

6 patches applied to wireless-drivers-next.git, thanks.

d2d1831723df rsi: add usb RS9113 chipset support
4833c953fd25 rsi: use enum for FSM states
015e367494c1 rsi: Register interrupt handler before firmware load
61f2a6fcaab1 rsi: receive path enhancement for RS9113
1b1bed016509 rsi: configure new boot parameters to device
9920322ccd8e rsi: add tx frame for common device configuration

-- 
https://patchwork.kernel.org/patch/9791875/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
