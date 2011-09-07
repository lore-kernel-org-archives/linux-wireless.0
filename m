Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42430 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab1IGUKE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Sep 2011 16:10:04 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.76)
	(envelope-from <johannes@sipsolutions.net>)
	id 1R1ORf-0007sZ-68
	for linux-wireless@vger.kernel.org; Wed, 07 Sep 2011 22:10:03 +0200
Message-Id: <20110907200744.076513799@sipsolutions.net> (sfid-20110907_221013_590498_5BFADCE8)
Date: Wed, 07 Sep 2011 22:07:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/11] AP powersaving clients changes
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

This series now has a little more than just uAPSD,
it also fixes some PS-poll issue and adds in an
optimisation of station flags handling.

Please review/comment.

johannes

