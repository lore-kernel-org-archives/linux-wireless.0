Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60617 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754109AbbA0KNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 05:13:45 -0500
Message-ID: <1422353616.1890.59.camel@sipsolutions.net> (sfid-20150127_111348_240103_7BD387B0)
Subject: Re: [PATCH 1/6] cfg80211: Fix BIP (AES-CMAC) cipher validation
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 27 Jan 2015 11:13:36 +0100
In-Reply-To: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
References: <1422121929-18238-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, all six applied, with the following changes:

Patch 1: use switch() statement
Patch 2: rebase and add to the switch() statement
Patch 4: fold in the ccmp256 -> mic_len change
Patch 5: rebase on top of the changed patch 4 (git am didn't work, patch
-p1 did)

johannes

