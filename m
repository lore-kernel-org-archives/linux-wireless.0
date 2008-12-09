Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.190]:29494 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbYLIELv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Dec 2008 23:11:51 -0500
Received: by ti-out-0910.google.com with SMTP id b6so859786tic.23
        for <linux-wireless@vger.kernel.org>; Mon, 08 Dec 2008 20:11:48 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18749.61316.313728.426082@localhost.localdomain> (sfid-20081209_051154_214509_67428776)
Date: Tue, 9 Dec 2008 09:39:40 +0530
To: daniel.c.halperin@intel.com
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: iwlwifi build failure
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

/home/sujith/dev/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c: In function 'iwl_rx_reply_rx':
/home/sujith/dev/wireless-testing/drivers/net/wireless/iwlwifi/iwl-rx.c:1074: error: 'struct iwl_priv' has no member named 'debug_level'

>From my .config:

CONFIG_IWLWIFI=m
CONFIG_IWLCORE=m
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=m
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y
# CONFIG_IWL3945 is not set

A missing #ifdef CONFIG_IWLWIFI_DEBUG in iwl-rx.c ?

Sujith
