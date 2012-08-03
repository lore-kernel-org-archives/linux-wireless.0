Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from store.l.unchti.me ([88.198.247.169]:44985 "EHLO
	store.l.unchti.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375Ab2HCMYs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Aug 2012 08:24:48 -0400
Received: from wlan249058.rz.uni-leipzig.de ([139.18.249.58] helo=spatula.rz.uni-leipzig.de)
	by store.l.unchti.me with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <mittagessen@l.unchti.me>)
	id 1SxGFX-0000Hb-BL
	for linux-wireless@vger.kernel.org; Fri, 03 Aug 2012 11:40:59 +0000
Date: Fri, 3 Aug 2012 13:41:16 +0200
From: Benjamin Kiessling <mittagessen@l.unchti.me>
To: linux-wireless@vger.kernel.org
Subject: MSDU aggregation with mac80211
Message-ID: <20120803114116.GA4172@spatula.rz.uni-leipzig.de> (sfid-20120803_142459_092893_06EEE366)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

is there any support for MSDU aggregation in drivers using mac80211 (in
my case ath9k)? I couldn't find any code in mac80211 itself or ath9k,
but I am not that familiar with the code base of either of them.

Regards,
Ben
