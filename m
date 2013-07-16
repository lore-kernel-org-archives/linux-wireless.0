Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288Ab3GPKpX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jul 2013 06:45:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Uz2kz-0007yn-EI
	for linux-wireless@vger.kernel.org; Tue, 16 Jul 2013 12:45:21 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] beacon measurement (beacon filtering disable)
Date: Tue, 16 Jul 2013 13:45:15 +0300
Message-Id: <1373971517-315-1-git-send-email-johannes@sipsolutions.net> (sfid-20130716_124528_666642_2CE45312)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have beacon filtering (to reduce host wakeups) in our device,
but for some measurement/debug purposes we need to turn it off.

This adds API for it -- comments welcome.

johannes

