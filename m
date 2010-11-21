Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:50952 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab0KUCSf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Nov 2010 21:18:35 -0500
Date: Sat, 20 Nov 2010 20:18:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org
Subject: [RFC PATCH 00/23] rtl8192ce: Introduce new driver
Message-ID: <4ce88170.VCtqm4WJU1N+oeT7%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch bomb contains the initial upload of a new Realtek driver for
the 802.11n wireless device in PCIe format with PCI IDs of 0x10ec:{0x8176,
0x8177, 0x8178, and 0x8191}. None of these devices have been previously
supported.

The bulk of the driver is as I got it from Realtek. My main contribution
has been to clean up the driver and take care of checkpatch and sparse
warnings and errors.

The firmware for this device is already in linux-firmware.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>

