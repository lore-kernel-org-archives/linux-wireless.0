Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:42239 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310AbYLSRGh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 12:06:37 -0500
From: Christian Lamparter <chunkeey@web.de>
To: wireless <linux-wireless@vger.kernel.org>
Subject: [RFC][PATCH 0/3] p54: p54spi driver
Date: Fri, 19 Dec 2008 18:06:35 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>, mb@bu3sch.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200812191806.36024.chunkeey@web.de> (sfid-20081219_180641_999433_1D6FE17F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series introduce the much longed back-end driver p54spi
for stlc4560/stlc4670 chips.

Words of warning:
This driver is highly experimental... In fact, all I know is that it will compile
without warnings... But I don't know if it set's fire on your N800.
---
 And in case someone likes numbers. Here's a diffstat of all changes:

 Kconfig         |    9 
 Makefile        |    1 
 p54.h           |   21 +
 p54common.c     |  258 +++++++++++++-----
 p54common.h     |   97 +++++--
 p54spi.c        |  774 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 p54spi.h        |  134 +++++++++
 p54spi_eeprom.h |  675 ++++++++++++++++++++++++++++++++++++++++++++++++
 8 files changed, 1875 insertions(+), 94 deletions(-)
