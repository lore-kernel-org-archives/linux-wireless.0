Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47039 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753299AbYHYVAr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Aug 2008 17:00:47 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m7PL0gVo031663
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 17:00:42 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m7PL0gfq054874
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 17:00:42 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m7PL0gHZ005726
	for <linux-wireless@vger.kernel.org>; Mon, 25 Aug 2008 17:00:42 -0400
Subject: [TESTING] Wireless mesh networking (802.11s) draft support
From: Subrata Modak <subrata@linux.vnet.ibm.com>
Reply-To: subrata@linux.vnet.ibm.com
To: Luis Carlos Cobo <luisca@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: ltp-list <ltp-list@lists.sourceforge.net>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 26 Aug 2008 02:30:31 +0530
Message-Id: <1219698032.5434.6.camel@subratamodak.linux.ibm.com> (sfid-20080825_230051_269932_DC7D066F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis/Johannes/John,

The Wireless mesh networking (802.11s) draft support has been added to
Linux 2.6.26. We at LTP (http://ltp.sourceforge.net/,
https://sourceforge.net/projects/ltp/) are trying to expand the test
coverage of all the untouched areas of kernel. With this drive in mind,
may i know if the testing infrastructure of Wireless mesh networking can
be shared with LTP under GPLv2. It would be a shot-in-the-arm for Linux
testing community, and, we can decide on how this can be best integrated
into LTP.

Regards--
Subrata

