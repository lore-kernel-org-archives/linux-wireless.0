Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab2LDOsh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 09:48:37 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
	(Exim 4.80)
	(envelope-from <johannes@sipsolutions.net>)
	id 1TftnY-0001js-38
	for linux-wireless@vger.kernel.org; Tue, 04 Dec 2012 15:48:36 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: regulatory cleanups & fixes
Date: Tue,  4 Dec 2012 15:48:42 +0100
Message-Id: <1354632540-21207-1-git-send-email-johannes@sipsolutions.net> (sfid-20121204_154923_597192_AF1553BE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

So I started looking at the regulatory code for VHT, and while
I'm not sure I will finish this right now here are a few (hah)
cleanups that I made while at it. Also a few fixes and the last
patch is a feature to not restrict the usable bandwidth.

johannes

