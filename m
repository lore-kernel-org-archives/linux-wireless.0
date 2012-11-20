Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39626 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab2KTJqI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:46:08 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so2291320bkw.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 01:46:07 -0800 (PST)
From: Florian Fainelli <florian@openwrt.org>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: john@phrozen.org, ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, zajec5@gmail.com, m@bues.ch
Subject: Re: [PATCH 8/8] MIPS: BCM47XX: remove GPIO driver
Date: Tue, 20 Nov 2012 10:44:23 +0100
Message-ID: <2709503.xrLFuOobtI@flexo> (sfid-20121120_104612_844028_FBB8746D)
In-Reply-To: <1353365877-11131-9-git-send-email-hauke@hauke-m.de>
References: <1353365877-11131-1-git-send-email-hauke@hauke-m.de> <1353365877-11131-9-git-send-email-hauke@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 19 November 2012 23:57:57 Hauke Mehrtens wrote:
> Instated of providing an own GPIO driver use the one provided by ssb and
> bcma.
> 
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>

Acked-by: Florian Fainelli <florian@openwrt.org>

Thanks Hauke!
--
Florian
