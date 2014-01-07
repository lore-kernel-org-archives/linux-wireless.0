Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572AbaAGXPX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jan 2014 18:15:23 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA256:128)
	(Exim 4.82)
	(envelope-from <johannes@sipsolutions.net>)
	id 1W0frj-00052E-TN
	for linux-wireless@vger.kernel.org; Wed, 08 Jan 2014 00:15:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 00/12] mac80211_hwsim: make radios more dynamic
Date: Wed,  8 Jan 2014 00:15:05 +0100
Message-Id: <1389136517-21216-1-git-send-email-johannes@sipsolutions.net> (sfid-20140108_001535_902999_E39A3FD0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is basically the legwork for allowing different hwsim radios
to have different properties, which will be useful for the tests
which can then create/destroy radios with different capabilities
are needed.

Comments welcome, I haven't really tested this yet.

johannes

