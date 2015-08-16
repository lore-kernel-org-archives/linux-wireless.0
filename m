Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:34323 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbbHPFak (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 16 Aug 2015 01:30:40 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] staging: wilc1000: code style patches
Date: Sun, 16 Aug 2015 01:30:11 -0400
Message-Id: <cover.1439702894.git.raphael.beamonte@gmail.com> (sfid-20150816_073150_810947_0579C3BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Please find in following emails code style patches for the driver
wilc1000 in staging.

Raphaël


Raphaël Beamonte (3):
  staging: wilc1000: code style: fix macro with multiple statements
  staging: wilc1000: code style: fix globals initialized to false
  staging: wilc1000: code style: fix open brace { on wrong line

 drivers/staging/wilc1000/host_interface.c         |  4 ++--
 drivers/staging/wilc1000/linux_wlan.c             |  3 +--
 drivers/staging/wilc1000/wilc_exported_buf.c      | 14 ++++++++------
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c |  3 +--
 drivers/staging/wilc1000/wilc_wlan.c              |  2 +-
 5 files changed, 13 insertions(+), 13 deletions(-)

-- 
2.1.4

