Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33438 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755988AbYFII4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jun 2008 04:56:55 -0400
Received: from imap1.linux-foundation.org (imap1.linux-foundation.org [140.211.169.55])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id m598uONn001847
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jun 2008 01:56:25 -0700
Received: from y.localdomain (localhost [127.0.0.1])
	by imap1.linux-foundation.org (8.13.5.20060308/8.13.5/Debian-3ubuntu1.1) with SMTP id m598uOib012068
	for <linux-wireless@vger.kernel.org>; Mon, 9 Jun 2008 01:56:24 -0700
Date: Mon, 9 Jun 2008 01:56:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-wireless@vger.kernel.org
Subject: CONFIG_IWL4965_HT=n in linux-next
Message-Id: <20080609015623.6bbc9d88.akpm@linux-foundation.org> (sfid-20080609_105721_218716_2FD3467F)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_siso_to_other':
drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1439: error: 'struct iwl_priv' has no member named 'current_ht_config'
drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1443: error: 'struct iwl_priv' has no member named 'current_ht_config'
drivers/net/wireless/iwlwifi/iwl-4965-rs.c: In function 'rs_move_mimo_to_other':
drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1530: error: 'struct iwl_priv' has no member named 'current_ht_config'
drivers/net/wireless/iwlwifi/iwl-4965-rs.c:1534: error: 'struct iwl_priv' has no member named 'current_ht_config'
