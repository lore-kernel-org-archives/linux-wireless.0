Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:47137 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750783Ab3FXNWh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 09:22:37 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] iwlwifi: add firmware for 7260 / 3160 devices
References: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Mon, 24 Jun 2013 15:20:52 +0200
In-Reply-To: <1372075552-3253-1-git-send-email-emmanuel.grumbach@intel.com>
	(Emmanuel Grumbach's message of "Mon, 24 Jun 2013 15:05:52 +0300")
Message-ID: <874ncny79n.fsf@nemi.mork.no> (sfid-20130624_152241_004103_9EF1DFA7)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Emmanuel Grumbach <emmanuel.grumbach@intel.com> writes:

> Add new firmware for new devices: 7260 and 3160
> version:
> 22.0.7.0


Thanks. That was quick. Looking good so far:

nemi:/home/bjorn# dmesg|grep iwl
[    4.687283] iwlwifi 0000:03:00.0: irq 45 for MSI/MSI-X
[    5.195061] iwlwifi 0000:03:00.0: loaded firmware version 22.0.7.0 op_mode iwlmvm
[    5.244709] iwlwifi 0000:03:00.0: Detected Intel(R) Dual Band Wireless AC 7260, REV=0x144
[    5.244885] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    5.245260] iwlwifi 0000:03:00.0: RF_KILL bit toggled to enable radio.
[    5.245452] iwlwifi 0000:03:00.0: L1 Disabled; Enabling L0S
[    5.488421] ieee80211 phy0: Selected rate control algorithm 'iwl-mvm-rs'



Bjørn
