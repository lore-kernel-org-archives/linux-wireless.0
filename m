Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netsys.kaist.ac.kr ([143.248.239.50]:56184 "EHLO
	netsys.kaist.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463AbZJTPjP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 11:39:15 -0400
Received: from JinsungLeePC (netsys30.kaist.ac.kr [143.248.239.70])
	by netsys.kaist.ac.kr (8.13.1/8.13.1) with ESMTP id n9KFb2q1008241
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2009 00:37:02 +0900
From: "Jinsung Lee" <ljs@netsys.kaist.ac.kr>
To: <linux-wireless@vger.kernel.org>
Subject: Question about getting TX queue parameter
Date: Wed, 21 Oct 2009 00:39:13 +0900
Message-ID: <01e601ca519b$799cf270$6cd6d750$@kaist.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I found the nice patch as follows:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=
318884875bdddca663ecc373c813cf8e117d9e43

This patch enables to set TX queue parameters such as txop, cwmin, cwmax and
aifs using NL80211_CMD_SET_WIPHY for userspace command (e.g.., iw).
I'm wondering if the above patch already includes the potential of getting
TX queue parameters using NL80211_CMD_GET_WIPHY for userspace command.
Does anyone have some idea for this?
Thanks.


--
Regards,
Jinsung Lee
--



