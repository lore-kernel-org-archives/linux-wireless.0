Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp06.msg.oleane.net ([62.161.4.6]:53945 "EHLO
	smtp06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756617AbaEEMRa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 May 2014 08:17:30 -0400
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp06.msg.oleane.net (MTA) with ESMTP id s45CHRPJ011595
	for <linux-wireless@vger.kernel.org>; Mon, 5 May 2014 14:17:27 +0200
Subject: DFS development Status
Date: Mon, 5 May 2014 14:17:26 +0200
Message-ID: <773DB8A82AB6A046AE0195C68612A319017BC92B@sbs2003.acksys.local> (sfid-20140505_141733_220027_E23514CB)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Cedric VONCKEN" <cedric.voncken@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

	Dear all,

	I'm read the web page
http://wireless.kernel.org/en/developers/DFS#Development_roadmap but the
roadmap is not updated since 2010.

	I understood the DFS required :
		Hostapd modifications
		Mac80211/cfg80211 modifications
		Regulatory/crda modifications
		Low level driver (ath9k,ath10k,...) modifications

	Where can I found the development status for each module ? Could
you give me the minimal version for each module ?

	I'm working with Wireless radio card with AR9xxx chipset, and on
several project the DFS is required.

	In ATH9K source file I found some code to configure the ETSI
pattern detection. Do you plan to support the latest ETSI pattern and
other pattern (FCC) ?

	Thanks for your help.

Cedric Voncken 

