Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:33688 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140AbaHVOND (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 10:13:03 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	nbd@nbd.name, thomas@net.t-labs.tu-berlin.de, ikstream86@gmail.com
Subject: [PATCH 0/2] Unify & improve Minstrel & Minstrel_HT rate control
Date: Fri, 22 Aug 2014 16:05:31 +0200
Message-Id: <1408716333-18492-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20140822_161308_056979_199CB294)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series consolidates rate statistic variables between Minstrel and
Minstrel_HT. It improves the sorting function to find the max throughput rate
set in Minstrel_HT.

