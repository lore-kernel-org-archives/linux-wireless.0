Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:28624 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753907Ab0GFHF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jul 2010 03:05:57 -0400
Subject: Re: [PATCH 02/15] wireless: wl1271: remove SDIO IDs from driver
From: Luciano Coelho <luciano.coelho@nokia.com>
To: ext Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	San Mehat <san@google.com>, Ohad Ben-Cohen <ohadb@ti.com>
In-Reply-To: <1278376666-3509-3-git-send-email-ohad@wizery.com>
References: <1278376666-3509-1-git-send-email-ohad@wizery.com>
	 <1278376666-3509-3-git-send-email-ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Jul 2010 10:04:54 +0300
Message-ID: <1278399894.18287.10.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-07-06 at 02:37 +0200, ext Ohad Ben-Cohen wrote:
> From: Ohad Ben-Cohen <ohadb@ti.com>
> 
> Remove SDIO IDs from the driver code since now it is
> included in linux/mmc/sdio_ids.h.
> 
> Signed-off-by: Ohad Ben-Cohen <ohadb@ti.com>
> ---

Acked-by: Luciano Coelho <luciano.coelho@nokia.com>

-- 
Cheers,
Luca.

