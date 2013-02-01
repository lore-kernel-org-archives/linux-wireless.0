Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59643 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab3BAQNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Feb 2013 11:13:49 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_CAMELLIA_256_CBC_SHA1:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1U1JFK-0000LI-Kp
	for linux-wireless@vger.kernel.org; Fri, 01 Feb 2013 17:13:47 +0100
Message-ID: <1359735250.8528.25.camel@jlt4.sipsolutions.net> (sfid-20130201_171352_678337_FCC35327)
Subject: rfkill/iw tarballs moved
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Fri, 01 Feb 2013 17:14:10 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've moved the rfkill and iw tarballs onto the proper kernel.org
storage, they're now available at

http://kernel.org/pub/software/network/rfkill/
and
http://kernel.org/pub/software/network/iw/

respectively. Properly signed (by me) with sha256sums provided by the
kernel.org robot.

I'm also asking John and Luis to move crda and wireless-regdb downloads,
they will be at

http://kernel.org/pub/software/network/crda/
and
http://kernel.org/pub/software/network/wireless-regdb/

johannes

