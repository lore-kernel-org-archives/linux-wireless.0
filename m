Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from argo.otaverkko.fi ([212.68.0.2]:60754 "EHLO argo.otaverkko.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752589Ab1CLNdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 08:33:37 -0500
Received: from localhost (hydra.otaverkko.fi [212.68.0.4])
	by argo.otaverkko.fi (Postfix) with ESMTP id 7739725ED73
	for <linux-wireless@vger.kernel.org>; Sat, 12 Mar 2011 15:01:04 +0200 (EET)
Message-ID: <1299934864.4d7b6e90712cb@webmail.hiit.fi>
Date: Sat, 12 Mar 2011 15:01:04 +0200
From: Konstantinos Georgantas <Konstantinos.Georgantas@hiit.fi>
To: linux-wireless@vger.kernel.org
Subject: Skip Open-System Authentication
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,
I am currently working on my thesis and as I am a beginner in kernel development
I face some problems.

I would like an indication of where the Open System Authentication takes place
in the code before the EAP process begins in RSNA networks.

More specifically, I would like to skip the specific Authentication and start
directly with the EAP one. After trying to analyze the code I am a little bit
confused (nl80211, cgf 80211 and mac80211 layers) and I would appreciate any
hint that could possibly help me. Even a document that describes the interaction
between this layers would help a lot.

Thank you a lot in advance. I would appreciate your advice.

Best regards,
Konstantinos Georgantas

