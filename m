Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out11.libero.it ([212.52.84.111]:50701 "EHLO
	cp-out11.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932074Ab1EKWTa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2011 18:19:30 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Subject: compile failure with commit 9c3990aaec0ad9f686ef6480f6861f2df89b2a7a
Date: Thu, 12 May 2011 00:19:24 +0200
MIME-Version: 1.0
Message-Id: <201105120019.24245.rossi.f@inwind.it> (sfid-20110512_001934_270121_C4A05D5C)
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  CC [M]  net/mac80211/cfg.o
net/mac80211/cfg.c: In function ‘sta_apply_parameters’:
net/mac80211/cfg.c:746: error: ‘struct sta_info’ has no member named 
‘plink_state’
make[2]: *** [net/mac80211/cfg.o] Error 1
make[1]: *** [net/mac80211] Error 2
make: *** [net] Error 2

I think because a #ifdef CONFIG_MAC80211_MESH is missing

Fabio
