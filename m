Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.227]:52435 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbYLPDbk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Dec 2008 22:31:40 -0500
Received: by rv-out-0506.google.com with SMTP id k40so2798398rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 15 Dec 2008 19:31:40 -0800 (PST)
From: Colin McCabe <colin@cozybit.com>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Cc: Andrey Yurovsky <andrey@cozybit.com>
Subject: [PATCH 0/3] libertas: driver for GSPI devices
Date: Mon, 15 Dec 2008 19:27:29 -0800
Message-Id: <1229398052-27465-1-git-send-email-colin@cozybit.com> (sfid-20081216_043153_461621_0E6B4B12)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


This patch series adds support for GSPI devices to libertas.
These devices are found in some embedded systems. We used a blackfin-based
board for development.

Since the blackfin has specific alignment requirements, this patch set includes
alignment fixes.

[PATCH 1/3] libertas: Fix alignment issues in libertas core
[PATCH 2/3] libertas: Update libertas core with GSPI constants
[PATCH 3/3] libertas: if_spi, driver for libertas GSPI devices

Sincerely,
Colin
