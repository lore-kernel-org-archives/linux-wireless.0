Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eazy.amigager.de ([213.239.192.238]:35073 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab2DRUpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2012 16:45:22 -0400
Received: from x61.home (mnch-5d85c5f6.pool.mediaWays.net [93.133.197.246])
	by eazy.amigager.de (Postfix) with ESMTPA id D8EE7F30046
	for <linux-wireless@vger.kernel.org>; Wed, 18 Apr 2012 22:35:48 +0200 (CEST)
Date: Wed, 18 Apr 2012 22:35:43 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: linux-wireless@vger.kernel.org
Subject: Power saving features for iwl4965
Message-ID: <20120418203543.GA16000@x61.home> (sfid-20120418_224526_110569_61770156)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

up to 2.6.38, the iwl4965 driver was able to use power saving features
by invoking "iwconfig <interface> power on", at least when unsetting
the broken_powersave variable.

2.6.39 introduced a new iwlegacy driver for iwl4965 hardware, which was
missing power saving.  I was able to port the 2.6.38 driver up to
kernel 3.1, but it got too complicated for me with 3.2. 

Are there any plans to fix this power usage regression at some point in
the iwlegacy driver? I think there are still a lot of iwl4965 users out
there.

Please include my address in any replies, as I'm not subscribed.

Regards,
Tino
