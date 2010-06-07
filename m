Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35560 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab0FGLDB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jun 2010 07:03:01 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OLa6d-0007AM-TD
	for linux-wireless@vger.kernel.org; Mon, 07 Jun 2010 13:03:00 +0200
Message-Id: <20100607110133.472649120@sipsolutions.net>
Date: Mon, 07 Jun 2010 13:01:33 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/21] sleeping ampdu_action
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

This massive series allows drivers to sleep
in ampdu_action.

Please review carefully. I have tested it
ONLY in hwsim so far.

johannes
