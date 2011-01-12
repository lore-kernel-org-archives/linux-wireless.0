Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50578 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab1ALMOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 07:14:08 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.0:RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1PczaZ-0001RQ-7M
	for linux-wireless@vger.kernel.org; Wed, 12 Jan 2011 13:14:07 +0100
Message-Id: <20110112121322.702618109@sipsolutions.net>
Date: Wed, 12 Jan 2011 13:13:22 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/2] fix aggregation buffer size limits
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luca and I found that we do not correctly handle
peers that want a limit (other than 64) on the
number of subframes in an aggregate. Here's a
completely untested attempt at fixing this.

Comments welcome.

johannes

