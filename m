Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:42372 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab0BPR4y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 12:56:54 -0500
Date: Tue, 16 Feb 2010 11:56:50 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Bernhard Schiffner <bernhard@schiffner-limbach.de>
Subject: [PATCH 0/5] rtl8187se: Initial commit
Message-ID: <4b7adc62.WqoY7DHjf+emK1/5%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This submission begins the introduction of a mainline driver for the
Realtek RTL8187SE PCI-based wireless device.

With John's permission, I will be submitting a number of small patches
so that review will be easier. I have taken care to ensure that each
step will build, thus preserving bisection through these changes.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

