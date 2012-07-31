Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:39048 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438Ab2GaLfp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jul 2012 07:35:45 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1SwAjn-0007Px-FF
	for linux-wireless@vger.kernel.org; Tue, 31 Jul 2012 13:35:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/3] A-MPDU status reporting
Date: Tue, 31 Jul 2012 13:35:38 +0200
Message-Id: <1343734541-14934-1-git-send-email-johannes@sipsolutions.net> (sfid-20120731_133547_495621_2A4EC38C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We just added A-MPDU status reporting in radiotap, this
implements it in mac80211 and iwlwifi. The changes will
be adopted formally next week so I'll merge the patches
then (into the different trees.)

johannes

