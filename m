Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50402 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab2FZMae (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jun 2012 08:30:34 -0400
From: Michal Kazior <michal.kazior@tieto.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [RFC v3] respect channels in iface combinations
Date: Tue, 26 Jun 2012 14:30:05 +0200
Message-ID: <1340713818-28549-1-git-send-email-michal.kazior@tieto.com> (sfid-20120626_143038_028017_0ACB9CA2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Here's a respin of my patches.

Changes:

 - add libertas set_channel tracking
 - add channel switch notify support (ap channel tracking)
 - introduce CFG80211_MAX_NUM_DIFFERENT_CHANNELS
   (changes channel accounting a bit)
 - add channel accounting for assoc

Left unchanged:

 - set_monitor_enabled callback name
 - initial monitor channel is set to first one found

Johannes, thanks again for your time and reviewing my patches.


-- Pozdrawiam / Best regards, Michal Kazior.


