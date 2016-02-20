Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ispras.ru ([83.149.199.45]:58293 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1947588AbcBTWax (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Feb 2016 17:30:53 -0500
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Andrea Merello <andrea.merello@gmail.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	ldv-project@linuxtesting.org
Subject: at76c50x-usb: usb_put_dev() if at76_load_internal_fw() succeed
Date: Sun, 21 Feb 2016 01:30:28 +0300
Message-Id: <1456007429-4713-1-git-send-email-khoroshilov@ispras.ru> (sfid-20160220_233143_555762_1F1D154D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I do not see any reason to call usb_put_dev() if at76_load_internal_fw() succeed.
But it is here from the very beginning. Any suggestions?

--
Thank you,
Alexey

