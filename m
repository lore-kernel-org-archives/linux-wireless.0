Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from serv04.lahn.de ([213.239.197.57]:54521 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752027Ab2BRSe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Feb 2012 13:34:59 -0500
Date: Sat, 18 Feb 2012 18:54:19 +0100
From: Michael Leun <lkml20120218@newton.leun.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-kernel@vger.kernel.org
Subject: Cannot put ath9k interface to different namespace?
Message-ID: <20120218185419.79376027@xenia.leun.net> (sfid-20120218_193621_030111_7D470738)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

tried to put ath9k_htc interface to namespace, does not work:

jill:/home/ml # ip link set netns 4001 dev wlan3
RTNETLINK answers: Invalid argument

Also does not work with ath9k, but does work with other wlan devices
(tried zd1201, r8712u, thats what I've here at the moment).

When trying, device was down.

Is there some trick to do it or is there some support from driver for
that missing?

Any plans to fix that? Would that be big effort?

Thanks.

-- 
MfG,

Michael Leun

