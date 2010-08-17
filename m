Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:50125 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372Ab0HQSbg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 14:31:36 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 0/3] compat-wireless: miscellaneous fixes
Date: Tue, 17 Aug 2010 20:31:06 +0200
Message-Id: <1282069869-22300-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This was build tested in combination with the patches to compat.

Hauke Mehrtens (3):
  compat-wireless: deactivate namespace
  compat-wireless: make compat-2.6.37.c build
  compat-wireless: fix hidp_output_raw_report

 config.mk                       |    2 +-
 patches/16-bluetooth.patch      |   37 +++++++++++++++++++++++--------------
 patches/32-remove-ns-type.patch |   28 ++++++++++++++++++++++++++++
 3 files changed, 52 insertions(+), 15 deletions(-)
 create mode 100644 patches/32-remove-ns-type.patch

