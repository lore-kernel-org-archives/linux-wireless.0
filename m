Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53493 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752898Ab1DOGY1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 02:24:27 -0400
Received: by pvg12 with SMTP id 12so921296pvg.19
        for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2011 23:24:26 -0700 (PDT)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19879.58665.384023.340355@gargle.gargle.HOWL>
Date: Fri, 15 Apr 2011 11:56:49 +0530
To: Rajkumar Manoharan <rmanoharan@atheros.com>
Cc: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] ath9k_htc: Add debugfs support to change debug mask
In-Reply-To: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
References: <1302848033-7072-1-git-send-email-rmanoharan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan wrote:
> +	priv->debug.debugfs_debug = debugfs_create_file("debug", S_IRUSR,
> +							priv->debug.debugfs_phy,
> +							priv, &fops_debug);
> +	if (!priv->debug.debugfs_debug)
> +		goto err;
> +

S_IWUSR ?

Sujith
