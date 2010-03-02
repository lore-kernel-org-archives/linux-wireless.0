Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:23671 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0CBIoB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 03:44:01 -0500
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 00:44:00 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19340.54345.580466.373621@gargle.gargle.HOWL>
Date: Tue, 2 Mar 2010 14:33:05 +0530
To: Sujith Manoharan <Sujith.Manoharan@atheros.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] ath9k: Add common code to lib
In-Reply-To: <19339.35501.467215.380773@gargle.gargle.HOWL>
References: <19339.35501.467215.380773@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John,

Can you drop this series (7/7) ?
We had a bit of confusion regarding sharing code between
ath9k and ath9k_htc. And it has been decided to just use
ath9k_common.ko.

Sorry for the trouble.

thanks,
Sujith
