Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:44571 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752260Ab0AYScR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:32:17 -0500
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Re: [PATCH 2/4] b43: make cordic common (LP-PHY and N-PHY need it)
Date: Mon, 25 Jan 2010 19:32:12 +0100
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <1264442401-6364-1-git-send-email-zajec5@gmail.com> <1264442401-6364-3-git-send-email-zajec5@gmail.com>
In-Reply-To: <1264442401-6364-3-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <201001251932.14633.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 25 January 2010 18:59:59 Rafał Miłecki wrote:
> +/* Complex number using 2 32-bit signed integers */
> +typedef struct { s32 i, q; } b43_c32;

No typedef. ever.

-- 
Greetings, Michael.
