Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36052 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab0HYU6Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 16:58:16 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OoN31-0005VM-EF
	for linux-wireless@vger.kernel.org; Wed, 25 Aug 2010 22:58:15 +0200
Message-Id: <20100825205619.152295081@sipsolutions.net>
Date: Wed, 25 Aug 2010 22:56:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 0/6] "runtime" iftype switching
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's some code to allow runtime (while the
interface is UP) interface type switching,
so far only for STA, IBSS and AP because the
others seem a bit trickier and harder to
verify.

Comments welcome. Not tested with HW yet :)

johannes

