Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42583 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909Ab1EWByX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:54:23 -0400
Date: Sun, 22 May 2011 20:54:22 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 0/7 V2] Fix warnings from gcc 4.6.0
Message-ID: <4dd9be4e.9vPhZCD73D/uOZQB%Larry.Finger@lwfinger.net> (sfid-20110523_035425_576628_C5320F03)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the introduction of gcc 4.6.0, a number of warnings for variables
that are set but not used are printed. With earlier versions, the
following construct was OK, but not any more:

declare foobar;
.
.
foobar = some_expression;

As some upstream maintainers have gotten cranky over warnings issued by
their compiler version, even when our compiles are clean, these warnings
need to be fixed.

Patches are submitted for the following wireless drivers:

1/7: b43
2/7: b43legacy
3/7: rtlwifi
4/7: rtl8192c-common
5/7: rtl8192ce
6/7: rtl8192cu
7/7: rtl8192se

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

V1 => V2: Fix submission script.

