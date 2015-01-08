Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40275 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752890AbbAHKNY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jan 2015 05:13:24 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
	(Exim 4.84)
	(envelope-from <johannes@sipsolutions.net>)
	id 1Y9A5i-0005Fp-P5
	for linux-wireless@vger.kernel.org; Thu, 08 Jan 2015 11:13:22 +0100
Message-ID: <1420711998.2029.5.camel@sipsolutions.net> (sfid-20150108_111327_587870_1E9C272C)
Subject: rfkill python module
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Thu, 08 Jan 2015 11:13:18 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

FYI - I just added a simple (but almost complete, save for the input
handling) python module for rfkill to the rfkill repository at
https://git.kernel.org/cgit/linux/kernel/git/jberg/rfkill.git/

johannes

