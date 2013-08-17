Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from forward19.mail.yandex.net ([95.108.253.144]:46735 "EHLO
	forward19.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab3HQMVq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Aug 2013 08:21:46 -0400
Received: from smtp17.mail.yandex.net (smtp17.mail.yandex.net [95.108.252.17])
	by forward19.mail.yandex.net (Yandex) with ESMTP id BEC9D11213C1
	for <linux-wireless@vger.kernel.org>; Sat, 17 Aug 2013 16:16:39 +0400 (MSK)
From: Sergey K <perplexus@ya.ru>
To: linux-wireless@vger.kernel.org
Cc: Sergey K <perplexus@ya.ru>
Subject: [PATCH 0/1] *** mac80211: delete duplicate code ***
Date: Sat, 17 Aug 2013 16:16:36 +0400
Message-Id: <1376741797-25505-1-git-send-email-perplexus@ya.ru> (sfid-20130817_142154_365600_90061418)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

*** BLURB HERE ***

Sergey K (1):
  Delete duplicate code. Use of the variable instead call a function

 net/mac80211/tx.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
1.8.1.5

