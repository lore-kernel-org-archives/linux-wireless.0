Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab2G3Ngf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jul 2012 09:36:35 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Svq9B-0005jj-Vn
	for linux-wireless@vger.kernel.org; Mon, 30 Jul 2012 15:36:34 +0200
Message-ID: <1343655393.4452.13.camel@jlt3.sipsolutions.net> (sfid-20120730_153639_738684_B6CA379C)
Subject: WDS vs. multi-channel operation
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 30 Jul 2012 15:36:33 +0200
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok so I'm chipping away at multi-channel operation, but WDS is
troubling. Which channel should it use? It doesn't even have channel
configuration today, but relies on having a channel already, but that
breaks when you have multi-channel since then it either has to have its
own channel or be slaved to another channel...

Anyone have any ideas?

johannes

