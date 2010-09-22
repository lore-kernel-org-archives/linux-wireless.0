Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.perfora.net ([74.208.4.195]:55164 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751969Ab0IVDfk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Sep 2010 23:35:40 -0400
Subject: Typo in wmi.c?
From: Estoy <estoy@voxsobrius.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 20:30:34 -0700
Message-ID: <1285126234.2142.3.camel@malta>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

compat-wireless-2010-09-20/drivers/staging/ath6kl/wmi/wmi.c

Line 1465: i&bhi   ?

Anyway I'm getting an "i" undefined error at line 1465 when building
from this release/file.

