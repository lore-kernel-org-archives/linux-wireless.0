Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:34507 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753361AbaIZImw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2014 04:42:52 -0400
Received: from smtp04.msg.oleane.net (smtp04.mail.priv [172.17.20.113])
	by smtp-out04.msg.oleane.net with ESMTP id s8Q8MQch031095
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 10:22:26 +0200
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp04.msg.oleane.net (MTA) with ESMTP id s8Q8239T011175
	for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2014 10:02:03 +0200
Subject: ath9k: DFS pattern detector and ETSI EN 301 893 V1.7.1
Date: Fri, 26 Sep 2014 10:02:03 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319018C215F@sbs2003.acksys.local> (sfid-20140926_104257_605024_0A1512E0)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Hi, 

	I will test my equipment with the ETSI standard EN 301 893
1.7.1.

	I looked the DFS pattern detector set in ath9k driver and the
"comment specifies" it compliant with the ETSI standard in V1.5.1.

	If I correctly understood the ath9k source code and the ETSI EN
301 893 standard, the table D.3 and D.4 in Annexes D of ETSI standard it
uses to fill the ETSI_radar_ref_types_v15 structure.

	The difference between these tables in EN 301 893 v1.5.1 and EN
301 893 v1.7.1 is only the minimal pulse width (from 0.8 to 0.5). This
value is set to 0 in many structure fields.

	Could you confirm the ETSI ath9k pattern detector is compatible
with the ETSI EN 301 893 v1.7.1 standard?

	If it is right, I will send a patch to precise that in ath9k
comment.

	Thanks for your help.

Cedric Voncken

