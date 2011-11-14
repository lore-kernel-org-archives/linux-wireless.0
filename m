Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms16-1.1blu.de ([89.202.0.34]:59608 "EHLO ms16-1.1blu.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab1KNNPL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 08:15:11 -0500
Received: from [79.254.124.83] (helo=hana.gusto)
	by ms16-1.1blu.de with esmtpsa (TLS-1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Exim 4.69)
	(envelope-from <gusto@guttok.net>)
	id 1RPvTy-0003cC-Po
	for linux-wireless@vger.kernel.org; Mon, 14 Nov 2011 13:17:51 +0100
Date: Mon, 14 Nov 2011 13:16:42 +0100
From: Lars Schotte <gusto@guttok.net>
To: linux-wireless@vger.kernel.org
Subject: iwlagn 3.0.9 aggreggation messages
Message-ID: <20111114131642.31e8ddbd@hana.gusto> (sfid-20111114_141517_380956_B0D5A07E)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i get always such aggreggation messages every 35 seconds since the
update from 3.0.8 to 3.0.9, so something is wrong there.

[  238.280312] iwlagn 0000:02:00.0: Aggregation not enabled for tid 0
because load = 0 [  335.575672] iwlagn 0000:02:00.0:
iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  400.605027]
iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
= 0 [  532.418136] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
20:4e:7f:5b:2d:f5 tid = 0 [  590.173035] iwlagn 0000:02:00.0:
iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [  616.193084]
iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
= 0 [  934.882300] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
20:4e:7f:5b:2d:f5 tid = 0 [  983.877888] iwlagn 0000:02:00.0:
iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0 [ 1048.354089]
iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid
= 0 [ 1137.254697] iwlagn 0000:02:00.0: iwlagn_tx_agg_start on ra =
20:4e:7f:5b:2d:f5 tid = 0 [ 1173.956035] iwlagn 0000:02:00.0:
iwlagn_tx_agg_start on ra = 20:4e:7f:5b:2d:f5 tid = 0

then there are no iwlagn drivers in 3.2 any more, but iwlwifi, what's
the difference between these two drivers?

-- 
Lars Schotte
@ Hana (F16)
