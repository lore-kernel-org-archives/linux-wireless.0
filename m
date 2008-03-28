Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48326 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751106AbYC1HdM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Mar 2008 03:33:12 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m2S7XAKU015582
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 00:33:11 -0700
Received: from y.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id m2S7XASU011732
	for <linux-wireless@vger.kernel.org>; Fri, 28 Mar 2008 00:33:10 -0700
Date: Fri, 28 Mar 2008 00:33:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: various printk warnings on ia64
Message-Id: <20080328003310.e7e119f5.akpm@linux-foundation.org> (sfid-20080328_073318_736949_761F6F00)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/ath5k/base.c: In function `ath5k_check_ibss_tsf':
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/ath5k/base.c:1740: warning: long long int format, u64 arg (arg 7)
drivers/net/wireless/ath5k/base.c:1740: warning: long long unsigned int format, u64 arg (arg 8)
drivers/net/wireless/ath5k/base.c:1757: warning: long long unsigned int format, u64 arg (arg 5)
drivers/net/wireless/ath5k/base.c:1757: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/iwlwifi/iwl4965-base.c: In function `iwl4965_tx_status_reply_tx':
drivers/net/wireless/iwlwifi/iwl4965-base.c:3105: warning: long long unsigned int format, u64 arg (arg 6)
drivers/net/wireless/iwlwifi/iwl-4965.c: In function `iwl4965_rx_reply_rx':
drivers/net/wireless/iwlwifi/iwl-4965.c:3978: warning: long long unsigned int format, u64 arg (arg 7)
