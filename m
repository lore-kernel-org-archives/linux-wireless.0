Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49589 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754049Ab2LLSef (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 13:34:35 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tir8a-0002LT-5a
	for linux-wireless@vger.kernel.org; Wed, 12 Dec 2012 19:34:32 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] VHT (and HT) channel restrictions
Date: Wed, 12 Dec 2012 19:34:54 +0100
Message-Id: <1355337296-5815-1-git-send-email-johannes@sipsolutions.net> (sfid-20121212_193437_913434_7A2926BF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Right now wpa_supplicant uses the current regulatory domain
(NL80211_CMD_GET_REG) to see if 40 MHz channels can be used
for not, but this is inaccurate as it doesn't take into  
account any possible driver restrictions.    

Here I'm adding VHT driver restrictions and advertise HT40
restrictions properly to fix the above issue.

johannes

