Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49718 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752376AbbCXUJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2015 16:09:54 -0400
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v4 0/10] Improve Minstrels & Minstrel-HTs common code base & statistics
Date: Tue, 24 Mar 2015 21:09:33 +0100
Message-Id: <1427227783-4531-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150324_210958_353487_8F1B3508)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds several improvements to the readability, the
output format of rc_stats and the calculated statistics of Minstrel
and Minstrel-HT. Variable names got more consistent and functions
got unified between both rate control algorithms.

Greetings Thomas

---
Changes in v2:
- fix define MACRO from CPTCFG_* into CONFIG_*
- change standard deviation symbol sigma into "sd"

Changes in v3:
- fix coding style of return value parts
- move tp_max calculation into tp_avg function in Minstrel-HT
- reorder function changes to make patch series consistent
(thx to Felix Fietkau for his review & comments)

Changes in v4:
- move tp_max calculation into tp_avg function in legacy Minstrel
- remove unused function declaration
(thx to Felix Fietkau for his review & comments)

[PATCH v4 01/10] mac80211: enhance readability of Minstrels rc_stats
[PATCH v4 02/10] mac80211: enhance readability of Minstrel-HTs
[PATCH v4 03/10] mac80211: add new Minstrel statistic output via csv
[PATCH v4 04/10] mac80211: add new Minstrel-HT statistic output via
[PATCH v4 05/10] mac80211: unify Minstrel & Minstrel-HTs calculation
[PATCH v4 06/10] mac80211: improve Minstrel variable & function
[PATCH v4 07/10] mac80211: restructure per-rate throughput
[PATCH v4 08/10] mac80211: add max lossless throughput per rate
[PATCH v4 09/10] mac80211: reduce calculation costs of EWMA
[PATCH v4 10/10] mac80211: add standard deviation to Minstrel stats
