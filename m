Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:17677 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbYE2Hee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 03:34:34 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: question about "context imbalance ...: wrong count at exit"
Date: Thu, 29 May 2008 09:34:27 +0200
Cc: libertas-dev@lists.infradead.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805290934.28027.hs4233@mail.mn-solutions.de> (sfid-20080529_093437_760327_B1819618)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/libertas/main.c:477:9: warning: context 
imbalance in 'lbs_eth_stop': wrong count at exit
drivers/net/wireless/libertas/main.c:477:9:    context 'lock': 
wanted 0, got
