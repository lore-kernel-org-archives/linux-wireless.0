Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost04.isp.att.net ([207.115.11.54]:44835 "EHLO
	fmailhost04.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbZFWPgO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 11:36:14 -0400
Message-ID: <4A40F674.9070907@lwfinger.net>
Date: Tue, 23 Jun 2009 10:36:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>, Chr <chunkeey@web.de>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/8] p54: Reorganize the driver
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current p54 family of drivers contains a large, undifferentiated
file and associated header that contain all the common code. This
series of patches will split this into several different files. The
last of the set is the only one that touches any files, thus this set
is fully bisectable.

Larry
