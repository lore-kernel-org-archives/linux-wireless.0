Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46839 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753677Ab1AUUrS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 15:47:18 -0500
Received: by ewy5 with SMTP id 5so1170225ewy.19
        for <linux-wireless@vger.kernel.org>; Fri, 21 Jan 2011 12:47:17 -0800 (PST)
From: Vasily Khoruzhick <anarsoul@gmail.com>
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Andrey Yurovsky <andrey@cozybit.com>,
	Colin McCabe <colin@cozybit.com>,
	Marek Vasut <marek.vasut@gmail.com>, anarsoul@gmail.com
Subject: [PATCH 0/3] libertas_spi fixes
Date: Fri, 21 Jan 2011 22:44:47 +0200
Message-Id: <1295642690-16646-1-git-send-email-anarsoul@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series attempts to fix libertas_spi bug (it calls functions that
may sleep from atomic context) and add pm support to libertas_spi.
Tested on Zipit Z2 device.

