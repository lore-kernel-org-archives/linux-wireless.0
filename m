Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:49835
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764420AbXGaVyh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2007 17:54:37 -0400
From: Michael Buesch <mb@bu3sch.de>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: iwl: large integer implicitly truncated to unsigned
Date: Tue, 31 Jul 2007 23:54:09 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200707312354.10118.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Are you aware of these warnings in current wireless-dev?

drivers/net/wireless/iwl-base.c:2061: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2062: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2063: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2064: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2065: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2071: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2072: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2073: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2074: warning: large integer implicitly truncated to unsigned type
drivers/net/wireless/iwl-base.c:2075: warning: large integer implicitly truncated to unsigned type

-- 
Greetings Michael.
