Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:33493 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750737AbdFOPuX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Jun 2017 11:50:23 -0400
Date: Thu, 15 Jun 2017 08:50:22 -0700
From: Kyle McMartin <kyle@infradead.org>
To: Aditya Shankar <aditya.shankar@microchip.com>
Cc: linux-wireless@vger.kernel.org, linux-firmware@kernel.org
Subject: Re: [PATCH] linux-firmware: wilc1000: Add unified firmware for
 wilc1000 WLAN
Message-ID: <20170615155022.GH13400@bombadil.infradead.org> (sfid-20170615_175027_042734_5CAA0E5E)
References: <1496479001-2733-1-git-send-email-aditya.shankar@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1496479001-2733-1-git-send-email-aditya.shankar@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 03, 2017 at 02:06:41PM +0530, Aditya Shankar wrote:
> This commit adds a new unified firmware for the wilc1000
> staging driver with below items addressed.
> 
> - Single firmware supports STA, AP and P2P modes.
> - Support suspend/resume on WILC1000.
> - Verify PS stability for WILC1000.
> - Bug fixes
> 
> Version of FW: v14.04
> 
> Signed-off-by: Aditya Shankar <aditya.shankar@microchip.com>

ok, thanks Aditya.
(i fixed the permissions on the firmware to be 644.)
--Kyle
