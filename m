Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from glaubenleben.de ([85.214.105.140]:57630 "EHLO glaubenleben.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969AbcAFVTO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 16:19:14 -0500
From: Andreas Kemnade <andreas@kemnade.info>
To: Kalle Valo <kvalo@codeaurora.org>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] wireless:libertas: ieee80211 powersave mode 
Date: Wed,  6 Jan 2016 22:08:08 +0100
Message-Id: <1452114494-6451-1-git-send-email-andreas@kemnade.info> (sfid-20160106_221917_226396_F440E09D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series makes IEEE 80211 powersave mode work again so
that power usage is dramatically reduced when the device is connected.
It does not include other power saving methods which are working
when the device is not connected (like enabling
deep sleep modus)

Tested on GTA04 which includes a
W2CBW003 chip (Marvel 8686) with sdio interface


[PATCH 1/6] wireless:libertas: do not strip header for PS_MODE
[PATCH 2/6] wireless:libertas: check whether bus can do more than
[PATCH 3/6] wireless:libertas: add an cfg80211 interface for
[PATCH 4/6] wireless:libertas: do not confirm sleep if commands are
[PATCH 5/6] wireless:libertas: go back to ps mode without commands
[PATCH 6/6] wireless:libertas: fix suspend problems
