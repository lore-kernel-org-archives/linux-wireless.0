Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41660 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751477Ab3A1JhY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Tzl9W-000730-Qo
	for linux-wireless@vger.kernel.org; Mon, 28 Jan 2013 10:37:23 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/37] iwlwifi: add the MVM driver
Date: Mon, 28 Jan 2013 10:37:07 +0100
Message-Id: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103728_069407_001EDD61)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Finally :-)

Here's our new MVM driver, along with 7000 device config and
some requisite cleanups. Obviously, I'm not going to split it
up into single patches for my pull request, but for the list
I have to.

We know that the rs.c code is ugly, it's copied from the old
code while we work on new code. Otherwise, the driver should
be pretty clean. Some small TODO items are left, as any other
driver this is work in progress :)

johannes

