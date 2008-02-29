Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:35229 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbYCCUUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2008 15:20:09 -0500
Received: by el-out-1112.google.com with SMTP id v27so330025ele.17
        for <linux-wireless@vger.kernel.org>; Mon, 03 Mar 2008 12:20:07 -0800 (PST)
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>
From: Luis Carlos Cobo <luisca@cozybit.com>
Date: Fri, 29 Feb 2008 12:13:38 -0800
Subject: [PATCH 00/10] mac80211: fix mesh remaining issues
Message-ID: <47cc5d75.24bc720a.7d54.ffffacc3@mx.google.com> (sfid-20080303_202053_897232_F04A36AD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patches fix all the remaining issues in the mesh implementation in
wireless-testing. The sparse endianness warnings have been solved and the mesh
option is no longer marked as BROKEN.

This applys on top of wireless-testing 6d85dc1886.


