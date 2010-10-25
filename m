Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:54719 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab0JYC2h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Oct 2010 22:28:37 -0400
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wl1251: fix module names
References: <1287703388-31683-1-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 25 Oct 2010 05:28:35 +0300
In-Reply-To: <1287703388-31683-1-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Fri\, 22 Oct 2010 02\:23\:08 +0300")
Message-ID: <87k4l70zvw.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> The wl1251 move accidently renamed wl1251_sdio and wl1251_spi
> modules to just sdio and spi. Restore proper module names.

Thank you for fixing my breakage.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
