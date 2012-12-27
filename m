Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50387 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2L0R7H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Dec 2012 12:59:07 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1ToHjU-0001dm-NM
	for linux-wireless@vger.kernel.org; Thu, 27 Dec 2012 18:59:05 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/3] (VHT) operating mode notification
Date: Thu, 27 Dec 2012 18:59:24 +0100
Message-Id: <1356631167-15192-1-git-send-email-johannes@sipsolutions.net> (sfid-20121227_185918_260165_4BF8DF9E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's an attempt to handle the new operating mode notifications.

So far, only NSS changes are supported, need to do some refactoring
to support bandwidth changes. Also, the operating mode can also be
in a beacon IE, need to add support for that.

johannes

