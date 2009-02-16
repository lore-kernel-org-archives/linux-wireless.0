Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:50526 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbZBPJGw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2009 04:06:52 -0500
Received: from mail.atheros.com ([10.10.20.86])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 16 Feb 2009 01:06:52 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18841.11203.428563.728384@gargle.gargle.HOWL> (sfid-20090216_100658_538857_6FCF8B9A)
Date: Mon, 16 Feb 2009 14:32:59 +0530
To: "linville@tuxdriver.com" <linville@tuxdriver.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/4] ath9k: Fix endiannes of EEPROM header
In-Reply-To: <18841.7130.956050.285308@gargle.gargle.HOWL>
References: <18841.7130.956050.285308@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> This patch fixes an endian-related issue when
> reading the EEPROM header.
> 

John,

Please drop this patch, will send a proper fix later.
The other 3 patches in the series can be applied. Thanks.

Sujith
