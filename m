Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:44543 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbZKLIPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2009 03:15:48 -0500
Received: from JinsungLeePC (netsys30.kaist.ac.kr [143.248.239.70])
	by netsys.kaist.ac.kr (8.13.1/8.13.1) with ESMTP id nAC8DTQw027290
	for <linux-wireless@vger.kernel.org>; Thu, 12 Nov 2009 17:13:29 +0900
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: <linux-wireless@vger.kernel.org>
Subject: ath9k: Unknown symbol
Date: Thu, 12 Nov 2009 17:15:39 +0900
Message-ID: <02a401ca6370$51fa0ff0$f5ee2fd0$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, all.

I installed compat-wireless-2009-11-12 and compiled successfully.
But when inputting the command "modprobe ath9k", I saw the following
message:

FATAL: Error inserting ath9k
(/lib/modules/2.6.32-020632rc6-generic/updates/drivers/net/wireless/ath/ath9
k/ath9k.ko): Unknown symbol in module, or unknown parameter (see dmesg)

And dmesg shows the following:

[582122.800191] ath9k: Unknown symbol ath9k_cmn_rx_skb_preprocess
[582122.803675] ath9k: Unknown symbol ath9k_cmn_rx_skb_postprocess

Actually, I haven't seen this kind of message before.
Is there any workaround solution for this?


--
Regards,
Jinsung Lee
--



