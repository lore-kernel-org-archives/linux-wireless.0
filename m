Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:14381 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbZAFKdI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 05:33:08 -0500
Received: by mu-out-0910.google.com with SMTP id g7so3020624muf.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Jan 2009 02:33:04 -0800 (PST)
Date: Tue, 6 Jan 2009 12:33:01 +0200
From: Valentin Manea <valentin.manea@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: IWL config.mk problems
Message-ID: <20090106123301.63ca1ea7@nero> (sfid-20090106_113313_447549_10454D83)
Reply-To: valentin.manea@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,


   The current config.mk in the latest compat wireless nightly is too old
and the IWL AGN drivers cannot be built. Instead of the current options, the
config should have something like:

CONFIG_IWLWIFI=y
CONFIG_IWLCORE=y
CONFIG_IWLWIFI_LEDS=y
CONFIG_IWLWIFI_RFKILL=y
# CONFIG_IWLWIFI_DEBUG is not set
CONFIG_IWLAGN=y
CONFIG_IWLAGN_SPECTRUM_MEASUREMENT=y
CONFIG_IWLAGN_LEDS=y
CONFIG_IWL4965=y
CONFIG_IWL5000=y

  I had a bug report on the Intel Wireless tracker but they told me I should
notify it here.


Thanks,
Valentin
