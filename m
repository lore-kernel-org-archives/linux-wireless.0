Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:52498 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1BGGqT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 01:46:19 -0500
Received: by pva4 with SMTP id 4so825762pva.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Feb 2011 22:46:19 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19791.38178.247980.202528@gargle.gargle.HOWL>
Date: Mon, 7 Feb 2011 12:15:54 +0530
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <David.Woodhouse@intel.com>, <dwmw2@infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH] Update ar9271.fw
In-Reply-To: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
References: <1297057905-2518-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
> * Enable bluetooth coexistence.
> * Fix disconnection issue with WEP and TKIP noticed in some APs.

Have you increased the ram segment size/offset in this patch ?

Changing the RAM layout on the target at random will certainly
introduce performance regressions.

Sujith
