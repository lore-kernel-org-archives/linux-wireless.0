Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:56470 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbYDJOle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2008 10:41:34 -0400
Message-Id: <20080410134810.629048000@sipsolutions.net> (sfid-20080410_154153_492244_2507A0BD)
Date: Thu, 10 Apr 2008 15:48:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-kernel@vger.kernel.org
Cc: Josh Triplett <josh@freedesktop.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	linux-wireless@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: [RFC 0/3] Examples for the new sparse context tracking
	functionality
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here are some patches that show how the new sparse functionality  
could be used in the kernel if merged.

As mentioned before, I have actually found three bugs in mac80211
using these patches. If you apply them and the sparse patches I have
also just posted, you can find them too :)

johannes

