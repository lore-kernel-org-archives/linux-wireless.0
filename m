Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49993 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751596AbaIIVWU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Sep 2014 17:22:20 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de, ikstream86@gmail.com
Subject: [PATCH v2 0/2] Unify & improve Minstrel & Minstrel_HT rate control 
Date: Tue,  9 Sep 2014 23:22:12 +0200
Message-Id: <1410297734-21187-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140909_232225_813300_D29EE896)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series consolidates rate statistic variables between Minstrel and
Minstrel_HT. It improves the sorting function to find the max throughput rate
set in Minstrel_HT.

---
v2: fix coding style, thx to Felix Fietkau

