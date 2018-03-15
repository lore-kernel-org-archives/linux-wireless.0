Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38962 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752084AbeCOMyQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Mar 2018 08:54:16 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-fbdev@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 11/16] treewide: simplify Kconfig dependencies for removed archs
References: <20180314143529.1456168-1-arnd@arndb.de>
        <20180314144614.1632190-1-arnd@arndb.de>
Date: Thu, 15 Mar 2018 14:54:07 +0200
In-Reply-To: <20180314144614.1632190-1-arnd@arndb.de> (Arnd Bergmann's message
        of "Wed, 14 Mar 2018 15:43:46 +0100")
Message-ID: <873711zehc.fsf@purkki.adurom.net> (sfid-20180315_135436_783297_75DA13AC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Arnd Bergmann <arnd@arndb.de> writes:

> A lot of Kconfig symbols have architecture specific dependencies.
> In those cases that depend on architectures we have already removed,
> they can be omitted.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

[...]

>  drivers/net/wireless/cisco/Kconfig   |  2 +-

Acked-by: Kalle Valo <kvalo@codeaurora.org>

-- 
Kalle Valo
