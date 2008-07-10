Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:2832 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGJQZz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 12:25:55 -0400
Received: by yx-out-2324.google.com with SMTP id 8so1123260yxm.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jul 2008 09:25:54 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Thu, 10 Jul 2008 16:56:25 +0200
Subject: [PATCH 0/6] libertastf: driver for Marvell 8388 with thin firmware.
Message-ID: <487637ed.07182c0a.6568.1fdd@mx.google.com> (sfid-20080710_182558_633123_8D77934B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This driver supports the Marvell 8388 USB wireless device, using a thin
firmware. The current "libertas" driver supports the same device but using a
fullmac firmware. Given the big differences in behavior between fullmac and
softmac firmwares, a new separate driver has been developed. Where possible
(specially for usb and fw upload), code has been borrowed from the original
libertas driver.

libertastf is a mac80211 driver that allows the use of 8388 as an AP with
hostap, or as a node in a o11s mesh. 

The appropriate firmware for this driver can be obtained at [1].

[1] http://dev.laptop.org/pub/firmware/libertas/thinfirm/


