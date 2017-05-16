Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:47890 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751305AbdEPQlL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 12:41:11 -0400
Date: Tue, 16 May 2017 09:41:07 -0700
From: Tony Lindgren <tony@atomide.com>
To: Sebastian Reichel <sebastian.reichel@collabora.co.uk>
Cc: Sebastian Reichel <sre@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 4/4] ARM: dts: omap4-droid4: Add bluetooth
Message-ID: <20170516164106.GL31418@atomide.com> (sfid-20170516_184133_247762_F240453A)
References: <20170503142226.32380-1-sebastian.reichel@collabora.co.uk>
 <20170503142226.32380-5-sebastian.reichel@collabora.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170503142226.32380-5-sebastian.reichel@collabora.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Sebastian Reichel <sebastian.reichel@collabora.co.uk> [170503 07:25]:
> Droid 4 has WL 1285C connected to the OMAP's UART4 port, which is
> used for Bluetooth and most likely can also be used for controlling
> the FM radio and GPS receivers.

I'm picking this patch and applying into omap-for-v4.13/dt thanks.

Tony
