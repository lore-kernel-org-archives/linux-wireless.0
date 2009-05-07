Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:21137 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbZEGCUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 May 2009 22:20:30 -0400
To: ext Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Linux Kernel Development <linux-kernel@vger.kernel.org>,
	"linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH next-20090506] wireless: WL12XX should depend on GENERIC_HARDIRQS
References: <Pine.LNX.4.64.0905062229370.23257@anakin>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 07 May 2009 05:19:21 +0300
In-Reply-To: <Pine.LNX.4.64.0905062229370.23257@anakin> (ext Geert Uytterhoeven's message of "Wed\, 6 May 2009 22\:35\:58 +0200")
Message-ID: <871vr1bqom.fsf@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ext Geert Uytterhoeven <geert@linux-m68k.org> writes:

> m68k allmodconfig:
> | drivers/net/wireless/wl12xx/main.c: In function 'wl12xx_probe':
> | drivers/net/wireless/wl12xx/main.c:1273: error: implicit declaration of function 'set_irq_type'
> | make[1]: *** [drivers/net/wireless/wl12xx/main.o] Error 1
>
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: Kalle Valo <kalle.valo@nokia.com>

-- 
Kalle Valo
