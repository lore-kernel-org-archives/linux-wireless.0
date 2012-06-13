Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:59611 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754392Ab2FMTGB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 15:06:01 -0400
Received: by lahj13 with SMTP id j13so758076lah.11
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 12:05:58 -0700 (PDT)
Message-ID: <1339614356.10534.66.camel@cumari.coelho.fi> (sfid-20120613_210605_246288_833FB648)
Subject: Re: [PATCH 0/2] wlcore/wl12xx: add suppoprt for HP and SKW FEM
 radio manufacturers
From: Luciano Coelho <coelho@ti.com>
To: Yair Shapira <yair.shapira@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 13 Jun 2012 22:05:56 +0300
In-Reply-To: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
References: <1339596862-2488-1-git-send-email-yair.shapira@ti.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-13 at 17:14 +0300, Yair Shapira wrote:
> Add support for HP(High Performance TQS fem type 3) and SKW (fem type 2)
> in radio params. BIP Calibration (PLT mode) of new radio types is supported
> In addition new log added to display BIP calibration radio_status
> 
> Yair Shapira (2):
>   wlcore/wl12xx: add suppoprt for HP and SKW FEM radio manufacturers
>   wlcore: add print logs of radio_status in case of BIP calibration
> 
>  drivers/net/wireless/ti/wl12xx/cmd.c      |   16 ++++++++++------
>  drivers/net/wireless/ti/wlcore/cmd.h      |   21 +++++++++++++++++++++
>  drivers/net/wireless/ti/wlcore/ini.h      |   22 +++++++++++++++++-----
>  drivers/net/wireless/ti/wlcore/testmode.c |   14 ++++++++++++++
>  4 files changed, 62 insertions(+), 11 deletions(-)
>  mode change 100644 => 100755 drivers/net/wireless/ti/wl12xx/cmd.c
>  mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/cmd.h
>  mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/ini.h
>  mode change 100644 => 100755 drivers/net/wireless/ti/wlcore/testmode.c

Applied and pushed, fixing some checkpatch bugs, including these
accidental file mode changes.

Thanks Yair!

--
Luca.

