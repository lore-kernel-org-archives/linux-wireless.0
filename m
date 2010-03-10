Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36678 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755602Ab0CJJgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Mar 2010 04:36:13 -0500
Content-Type: text/plain; charset="iso-8859-1"
Date: Wed, 10 Mar 2010 10:36:10 +0100
From: "Philipp Hofmann" <pho@gmx.net>
Message-ID: <20100310093610.138790@gmx.net>
MIME-Version: 1.0
Subject: ath5k: (how) does diversity with 5006 family chips work?
To: linux-wireless@vger.kernel.org
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the specifications available from Atheros, the chips of family 5006 (e.g., 5413 and 5414) do only have one antenna port.

However, WLAN boards with those chips do have two antenna ports. Also, madwifi and ath5k drivers support two antenna ports and allow setting a fixed port for transmitting/receiving or automatic mode supporting diversity.

Can someone explain what kind of diversity is supported here? What is the advantage of using diversity? In experiments, we did not see any difference in performance (throughput, range) between setting fixed antenna ports and using automatic mode/diversity.

Cheers,
Philipp
-- 
GMX DSL: Internet, Telefon und Entertainment für nur 19,99 EUR/mtl.!
http://portal.gmx.net/de/go/dsl02
