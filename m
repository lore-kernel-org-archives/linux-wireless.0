Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41080 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab2J3IHK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Oct 2012 04:07:10 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TT6qq-0006ln-B5
	for linux-wireless@vger.kernel.org; Tue, 30 Oct 2012 09:07:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/4] iwlwifi: some 3.8 updates
Date: Tue, 30 Oct 2012 09:07:39 +0100
Message-Id: <1351584463-11469-1-git-send-email-johannes@sipsolutions.net> (sfid-20121030_090719_610608_09EBA71A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Again we don't have a lot, we've decided to remove the MFP
option as it turns out to be insecure in the firmware if it
doesn't have the keys, a fix for a PCIe transport issue we
found with our new code and a new transport buffer flag to
allow copying a block of memory so the higher layer doesn't
have to track the command lifetime.

johannes

