Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37938 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753357Ab1EWBr2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 21:47:28 -0400
Date: Sun, 22 May 2011 20:47:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John W Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Message-ID: <4dd9bca8.eugGG+ih8qAlyqvy%Larry.Finger@lwfinger.net> (sfid-20110523_034732_508713_1F73A552)
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
