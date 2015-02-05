Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.net.t-labs.tu-berlin.de ([130.149.220.252]:43687 "EHLO
	mail.net.t-labs.tu-berlin.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523AbbBECT0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2015 21:19:26 -0500
From: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@nbd.name,
	thomas@net.t-labs.tu-berlin.de
Subject: [PATCH 0/10] Improve Minstrels & Minstrel-HTs common code base & statistics
Date: Thu,  5 Feb 2015 03:13:10 +0100
Message-Id: <1423102400-9693-1-git-send-email-thomas@net.t-labs.tu-berlin.de> (sfid-20150205_031939_068320_89684D92)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch series adds several improvements to the readability, the
output format of rc_stats and the calculated statistics of Minstrel
and Minstrel-HT. Variable names got more consistent and functions
got unified between both rate control algorithms.

Greetings Thomas



[PATCH 01/10] mac80211: enhance readability of Minstrels rc_stats
[PATCH 02/10] mac80211: enhance readability of Minstrel-HTs rc_stats
[PATCH 03/10] mac80211: add new Minstrel statistic output via csv
[PATCH 04/10] mac80211: add new Minstrel-HT statistic output via csv
[PATCH 05/10] mac80211: unify Minstrel & Minstrel-HTs calculation of
[PATCH 06/10] mac80211: improve Minstrel variable & function naming
[PATCH 07/10] mac80211: restructure per-rate throughput calculation
[PATCH 08/10] mac80211: add max. lossless throughput per rate to
[PATCH 09/10] mac80211: reduce calculation costs of EWMA
[PATCH 10/10] mac80211: add standard deviation to Minstrels

net/mac80211/rc80211_minstrel.c            | 129 +++++++++++------
net/mac80211/rc80211_minstrel.h            |  50 +++++--
net/mac80211/rc80211_minstrel_debugfs.c    | 130 ++++++++++++++---
net/mac80211/rc80211_minstrel_ht.c         | 216 +++++++++++++++-------------
net/mac80211/rc80211_minstrel_ht.h         |   5 +-
net/mac80211/rc80211_minstrel_ht_debugfs.c | 224 +++++++++++++++++++++++++----
6 files changed, 553 insertions(+), 201 deletions(-)
