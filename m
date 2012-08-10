Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44244 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2HJSET (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Aug 2012 14:04:19 -0400
Date: Fri, 10 Aug 2012 13:47:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org,
	=?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Subject: Re: [PATCH 2/3] bcma: add GPIO driver for SoCs
Message-ID: <20120810174748.GA1950@tuxdriver.com> (sfid-20120810_200456_402514_E4CCC7FB)
References: <1344165123-4640-1-git-send-email-hauke@hauke-m.de>
 <1344165123-4640-3-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1344165123-4640-3-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Aug 05, 2012 at 01:12:02PM +0200, Hauke Mehrtens wrote:
> The GPIOs are access through some registers in the chip common core.
> We need locking around these GPIO accesses, all GPIOs are accessed
> through the same registers and parallel writes will cause problems.
> 
> CC: Rafał Miłecki <zajec5@gmail.com>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

ACK to the bcma bits going through Ralf's tree...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
