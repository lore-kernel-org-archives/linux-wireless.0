Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37624 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbcDRQrt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2016 12:47:49 -0400
To: Christian Lamparter <chunkeey@googlemail.com>,
	Lauri Kasanen <cand@gmx.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev@vger.kernel.org,
	Linux Firmware Maintainers <linux-firmware@kernel.org>
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: Re: [PATCH v2] carl9170: Clarify kconfig text
Message-ID: <c17f2f12-1c94-6b19-c918-0a6a9ee401ca@gmail.com> (sfid-20160418_184808_105249_2B330A76)
Date: Mon, 18 Apr 2016 18:47:44 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Lamparter wrote:

> Sure, but this could be a different patch then. I think Intel devices 
> (iwlwifi, iwlegacy and ipw2x00) have a similar text about "download
> firmware from this device from our homepage here" too. So if we want,
> we can remove them altogether?

linux-firmware.git does not contain firmware for all drivers. _At least_
zd1211rw [1], atmel [2] and ipw2x00 [3] are out of the tree.

[1] http://sf.net/projects/zd1211/files/
[2] http://web.archive.org/web/20121016132320/http://at76c503a.berlios.de/fw_dl.html
[3] http://ipw2100.sf.net/firmware.php http://ipw2200.sf.net/firmware.php
