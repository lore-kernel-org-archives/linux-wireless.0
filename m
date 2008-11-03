Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31997 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751064AbYKCWnF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 17:43:05 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 03 Nov 2008 14:43:05 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 0/3] ath5k/ath9k: few filter patches
Date: Mon, 3 Nov 2008 14:42:58 -0800
Message-ID: <1225752181-1343-1-git-send-email-lrodriguez@atheros.com> (sfid-20081103_234313_610196_4630F392)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a few set of patches for ath5k and ath9k which should
help with connectivity issues. One of these requires a revert
so I'm just requesting it in the e-mail. These all address filter
flags.

  Luis
