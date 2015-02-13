Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:49150 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752377AbbBMO6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2015 09:58:04 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH v2 0/10] Improve Minstrels & Minstrel-HTs common code base & statistics 
Date: Fri, 13 Feb 2015 15:57:42 +0100
Message-Id: <1423839472-15625-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150213_155808_461719_C94B7B79)
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

[PATCH v2 01/10] mac80211: enhance readability of Minstrels rc_stats
[PATCH v2 02/10] mac80211: enhance readability of Minstrel-HTs
[PATCH v2 03/10] mac80211: add new Minstrel statistic output via csv
[PATCH v2 04/10] mac80211: add new Minstrel-HT statistic output via
[PATCH v2 05/10] mac80211: unify Minstrel & Minstrel-HTs calculation
[PATCH v2 06/10] mac80211: improve Minstrel variable & function
[PATCH v2 07/10] mac80211: restructure per-rate throughput
[PATCH v2 08/10] mac80211: add max. lossless throughput per rate to
[PATCH v2 09/10] mac80211: reduce calculation costs of EWMA
[PATCH v2 10/10] mac80211: add standard deviation to Minstrels
