Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46539 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045Ab0FIPG7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jun 2010 11:06:59 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.71)
	(envelope-from <johannes@sipsolutions.net>)
	id 1OMMrq-00087F-Bj
	for linux-wireless@vger.kernel.org; Wed, 09 Jun 2010 17:06:58 +0200
Message-Id: <20100609150142.227469359@sipsolutions.net>
Date: Wed, 09 Jun 2010 17:01:42 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC v2 00/22] aggregation locking rework v2
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Second posting of the series to allow drivers to sleep
in ampdu_action. Now with a few bugfixes (very minor)
and documentation updates.

We'll be subjecting it to some more testing, and then
I expect to post it for inclusion in the next couple of
days.

johannes



