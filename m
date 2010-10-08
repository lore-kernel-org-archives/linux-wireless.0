Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:22686 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932293Ab0JHNma (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 09:42:30 -0400
Subject: pull-request: wl12xx 2010-10-08
From: Luciano Coelho <luciano.coelho@nokia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Oct 2010 16:42:17 +0300
Message-ID: <1286545337.21349.177.camel@chilepepper>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

These are two patches that allow the wl1271 chip to be powered on and
off over SDIO.  As we discussed on IRC, they depend on other changes
which already are in the mmc-next tree.

Please pull this to wireless-next.

The following changes since commit 15a6321d1c0f8db561932cd99e1b9897981da71f:
  Rajkumar Manoharan (1):
        ath9k_hw: Fix hw reset failure with HTC driver

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/luca/wl12xx.git wireless-next

Ohad Ben-Cohen (2):
      wl1271: sdio: enable runtime PM
      wl1271: sdio: add suspend/resume support

 drivers/net/wireless/wl12xx/wl1271_sdio.c |   43 +++++++++++++++++++++++++----
 1 files changed, 37 insertions(+), 6 deletions(-)

-- 
Cheers,
Luca.

