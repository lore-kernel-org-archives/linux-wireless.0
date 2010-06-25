Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:53777 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751750Ab0FYIh4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jun 2010 04:37:56 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 25 Jun 2010 01:37:56 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19492.27490.4534.630253@gargle.gargle.HOWL>
Date: Fri, 25 Jun 2010 14:10:02 +0530
To: "atheros.eng.projects.ath9k-devel@mailman.users.atheros.com"
	<atheros.eng.projects.ath9k-devel@mailman.users.atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [internal-ath9k-devel] [PATCH v2] ath9k: declare MODULE_FIRMWARE for ath9k_htc
In-Reply-To: <1277319039-20837-1-git-send-email-linville@tuxdriver.com>
References: <1277317393-20245-1-git-send-email-linville@tuxdriver.com>
	<1277319039-20837-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---
> v2 -> avoid duplicate strings for firmware names and simultaneously
> 	attract attention to MODULE_FIRMWARE section in the even of
> 	any updates
> 

Neat, thanks.

Sujith
