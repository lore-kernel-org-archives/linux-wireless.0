Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:33620 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbbHQT2m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 15:28:42 -0400
From: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: =?UTF-8?q?Rapha=C3=ABl=20Beamonte?= <raphael.beamonte@gmail.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org,
	Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCHv2 0/5] staging: wilc1000: code improvements
Date: Mon, 17 Aug 2015 15:28:25 -0400
Message-Id: <cover.1439838526.git.raphael.beamonte@gmail.com> (sfid-20150817_213053_203914_A77E28A8)
In-Reply-To: <cover.1439827537.git.raphael.beamonte@gmail.com>
References: <cover.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Following comments from Dan Carpenter, please find the following
revised patches.

Raphaël


Raphaël Beamonte (5):
  staging: wilc1000: remove void function return statements that are not
    useful
  staging: wilc1000: use pr_* instead of printk
  staging: wilc1000: remove DECLARE_WILC_BUFFER()
  staging: wilc1000: remove FREE_WILC_BUFFER()
  staging: wilc1000: replace MALLOC_WILC_BUFFER() macro to avoid
    possible memory leak

 drivers/staging/wilc1000/coreconfigurator.c  |  4 +-
 drivers/staging/wilc1000/host_interface.c    |  4 --
 drivers/staging/wilc1000/linux_wlan.c        |  9 ++--
 drivers/staging/wilc1000/linux_wlan_common.h | 28 ++++++-------
 drivers/staging/wilc1000/linux_wlan_sdio.c   |  2 +-
 drivers/staging/wilc1000/linux_wlan_spi.c    |  2 +-
 drivers/staging/wilc1000/wilc_debugfs.c      | 16 ++++----
 drivers/staging/wilc1000/wilc_exported_buf.c | 61 ++++++++++++++++------------
 drivers/staging/wilc1000/wilc_wlan.c         |  3 --
 drivers/staging/wilc1000/wilc_wlan_cfg.c     |  2 -
 10 files changed, 64 insertions(+), 67 deletions(-)

-- 
2.1.4

