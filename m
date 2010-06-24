Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52425 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab0FXXet convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jun 2010 19:34:49 -0400
Received: by bwz7 with SMTP id 7so452239bwz.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jun 2010 16:34:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1277420940.28625.30.camel@gnutoo-laptop>
References: <1275693948-3189-1-git-send-email-notasas@gmail.com>
	<1275693948-3189-2-git-send-email-notasas@gmail.com>
	<AANLkTinqgUGCjCBzg8j7bXGY05EW3-jfW7vlnrvCuwRd@mail.gmail.com>
	<1277124410.28895.23.camel@gnutoo-laptop>
	<AANLkTimLKDqDn_97BbOYr1cdxbFdPvyTz_lxJ59LVJ1b@mail.gmail.com>
	<1277145901.28895.29.camel@gnutoo-laptop>
	<AANLkTildbagKqzTQbcZ8cT53s4L2OWpJ5fkBUTcejj0h@mail.gmail.com>
	<1277249607.2233.270.camel@gnutoo-laptop>
	<1277420940.28625.30.camel@gnutoo-laptop>
Date: Fri, 25 Jun 2010 02:34:47 +0300
Message-ID: <AANLkTinGVsGRFZ5J06Y_s13TGjJcIRbm2ugfNfgSCIEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] wl1251: fix ELP_CTRL register reads
From: Grazvydas Ignotas <notasas@gmail.com>
To: "Denis 'GNUtoo' Carikli" <GNUtoo@no-log.org>
Cc: Bob Copeland <me@bobcopeland.com>, Kalle Valo <kvalo@adurom.com>,
	"John W.Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I've changed that struct to wl12xx_platform_Data and added the irq
> int,and I've still the following errors:
> [  541.676849] wl1251: ERROR sdio_writeb failed (-84)
> [  542.006378] mmc0: Command timeout
> [  542.011444] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [  543.016357] mmc0: Command CRC error
> [  543.016418] mmc0:0001: error -84 reading SDIO_CCCR_INTx
> [  544.026367] mmc0: Command timeout
> [  544.031433] mmc0:0001: error -110 reading SDIO_CCCR_INTx
> [  545.036376] mmc0: Command CRC error

Has powersaving ever worked on your device with this driver? It does
work fine on pandora (OMAP3).
