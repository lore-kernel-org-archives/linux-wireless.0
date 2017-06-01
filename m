Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:48152 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751148AbdFARWr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 13:22:47 -0400
Date: Thu, 1 Jun 2017 10:22:46 -0700
From: Kyle McMartin <kyle@infradead.org>
To: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        linux-firmware@kernel.org
Subject: Re: [PATCH] linux-firmware: add firmware image for Redpine 9113
 chipset
Message-ID: <20170601172246.GB13400@bombadil.infradead.org> (sfid-20170601_192251_428942_D674D05C)
References: <1496236783-3250-1-git-send-email-amit.karwar@redpinesignals.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496236783-3250-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 31, 2017 at 06:49:43PM +0530, Amitkumar Karwar wrote:
> This image will be loaded by rsi driver. Firmware version is 1.5.3
> 
> Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Applied, thanks Amitkumar.

--kyle

> ---
>  WHENCE                   |   3 +++
>  rsi/rs9113_wlan_qspi.rps | Bin 0 -> 199180 bytes
>  2 files changed, 3 insertions(+)
>  create mode 100644 rsi/rs9113_wlan_qspi.rps
> 
