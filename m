Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:1942 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935364AbZJOUFh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 16:05:37 -0400
Received: by ey-out-2122.google.com with SMTP id 9so297890eyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2009 13:04:29 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/2] rt2x00: Implement support for rt2800pci
Date: Thu, 15 Oct 2009 22:04:14 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Alban Browaeys <prahal@yahoo.com>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	Felix Fietkau <nbd@openwrt.org>,
	Luis Correia <luis.f.correia@gmail.com>,
	Mattias Nissler <mattias.nissler@gmx.de>,
	Mark Asselstine <asselsm@gmail.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>
References: <200910152137.58164.IvDoorn@gmail.com>
In-Reply-To: <200910152137.58164.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910152204.16407.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for the rt2860/rt3090 chipsets from Ralink.

Includes various patches from a lot of people who helped
getting this driver into the current shape.

Signed-off-by: Alban Browaeys <prahal@yahoo.com>
Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Signed-off-by: Luis Correia <luis.f.correia@gmail.com>
Signed-off-by: Mattias Nissler <mattias.nissler@gmx.de>
Signed-off-by: Mark Asselstine <asselsm@gmail.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
http://kernel.org/pub/linux/kernel/people/ivd/patches/0003-rt2x00-Implement-support-for-rt2800pci.patch
