Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:56157 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab0I2DMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 23:12:00 -0400
Subject: Re: [PATCH v2] linux-firmware: wl12xx-Add Firmware and NVS files
 to support Texas Instruments WLAN driver
From: David Woodhouse <dwmw2@infradead.org>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org,
	Luciano Coelho <luciano.coelho@nokia.com>
In-Reply-To: <1285682308-20189-1-git-send-email-shahar_levi@ti.com>
References: <1285682308-20189-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 12:11:53 +0900
Message-ID: <1285729913.814.78.camel@macbook.infradead.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-09-28 at 15:58 +0200, Shahar Levi wrote:
> +5. Export Control.  Thesoftware programsand any "on-line"
> documentationas well as any updates or 

The LICENCE file seems to be littered with 0xA0 bytes where you should
have spaces — are these non-breaking spaces in some legacy character
set? This is the 21st century — please use only UTF-8. And can we make
this fit in 80 columns while we're at it?

-- 
dwmw2

