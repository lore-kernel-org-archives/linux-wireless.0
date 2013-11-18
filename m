Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hetz2.bluebottle.com ([176.9.57.138]:55592 "EHLO
	fe0.bluebottle.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751141Ab3KRLVU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 06:21:20 -0500
Received: from localhost (pD9FDC255.dip0.t-ipconnect.de [217.253.194.85])
	(using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: bittorf@bluebottle.com)
	by fe0.bluebottle.com (Postfix) with ESMTPSA id EE07F2501B
	for <linux-wireless@vger.kernel.org>; Mon, 18 Nov 2013 11:12:56 +0000 (UTC)
Date: Mon, 18 Nov 2013 12:20:25 +0100
From: Bastian Bittorf <bittorf@bluebottle.com>
To: linux-wireless@vger.kernel.org
Subject: iw: query mcast-rate from commandline
Message-ID: <20131118112025.GV886@medion.lan> (sfid-20131118_122130_740335_7744E355)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

i'am using wireless-testing 2013-11-05 on OpenWrt. it is
possible since a long time (2011?) to _set_ mcast-rate
for each VIF, but to to query e.g. via 'iw dev wlan0-1 info'.

also i didnt found anything related in the documentation.
has somebody done work for this, or should i try to add it?

bye, bastian
