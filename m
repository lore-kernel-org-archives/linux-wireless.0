Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:62501 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755169AbZLHOV7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2009 09:21:59 -0500
From: Stefan Seyfried <stefan.seyfried@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Stefan Seyfried <seife@sphairon.com>
Subject: [PATCH 0/2] Add support for Sphairon Homelink 1202 USB WLAN
Date: Tue,  8 Dec 2009 15:21:33 +0100
Message-Id: <1260282095-17042-1-git-send-email-stefan.seyfried@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stefan Seyfried <seife@sphairon.com>

The following two trivial patches add support for this device to
zd1211rw (ejecting the virtual USB drive) and ar9170usb (that drives
the WLAN chip inside).

Best regards,

	Stefan Seyfried
