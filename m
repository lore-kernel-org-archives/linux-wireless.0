Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4156 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758308Ab0DPMT7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 08:19:59 -0400
Date: Fri, 16 Apr 2010 08:15:47 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kalle Valo <kalle.valo@iki.fi>
Subject: Re: [PATCH] wl1251: add support for dedicated IRQ line
Message-ID: <20100416121547.GA10649@hash.localnet>
References: <1271413332-2979-1-git-send-email-notasas@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1271413332-2979-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 16, 2010 at 01:22:12PM +0300, Grazvydas Ignotas wrote:
> wl1251 has WLAN_IRQ pin for generating interrupts to host processor,
> which is mandatory in SPI mode and optional in SDIO mode (which can
> use SDIO interrupts instead). However TI recommends using deditated
> IRQ line for SDIO too.
> 
> Add support for using dedicated interrupt line with SDIO, but also leave
> ability to switch to SDIO interrupts in case it's needed.
> 
> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Thanks, looks good to me!

Reviewed-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

