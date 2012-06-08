Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:40842 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934249Ab2FHUae (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2012 16:30:34 -0400
Received: by dady13 with SMTP id y13so2805221dad.19
        for <linux-wireless@vger.kernel.org>; Fri, 08 Jun 2012 13:30:34 -0700 (PDT)
From: Jason Abele <jason@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH 0/2] mac80211: mesh remove unused var and fix naming
Date: Fri,  8 Jun 2012 13:30:23 -0700
Message-Id: <1339187425-12549-1-git-send-email-jason@cozybit.com> (sfid-20120608_223038_843264_3B2D128A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

formerly sent as 2 and 4 respectively in:
	[PATCH v3 0/5] Improvement to initial mesh metric

Javier Cardona (2):
  mac80211: Remove unused variable
  mac80211: Rename stainfo variable for the more common sta

 net/mac80211/mesh.h      |    2 +-
 net/mac80211/mesh_hwmp.c |   11 ++++-------
 2 files changed, 5 insertions(+), 8 deletions(-)

-- 
1.7.9.5

