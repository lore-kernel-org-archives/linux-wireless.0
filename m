Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63898 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116Ab3ARMFl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 07:05:41 -0500
Received: by mail-bk0-f46.google.com with SMTP id q16so1969777bkw.33
        for <linux-wireless@vger.kernel.org>; Fri, 18 Jan 2013 04:05:39 -0800 (PST)
From: Marco Porsch <marco@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Marco Porsch <marco@cozybit.com>
Subject: [PATCH 0/3] iw: mesh power save
Date: Fri, 18 Jan 2013 13:05:29 +0100
Message-Id: <1358510732-32767-1-git-send-email-marco@cozybit.com> (sfid-20130118_130544_199219_1A66681A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following commits cover all neccessary iw commands for mesh
power save. Beacon interval, DTIM period, default power mode and
awake window are accessed as part of the mesh params. The
link-specific power modes are set for peer STA.

Marco Porsch (3):
  iw: add beacon interval and DTIM period parameters to mesh join
  iw: add default mesh Power Mode and Awake Window to mesh config
  iw: add support for link-specific mesh power modes

 mesh.c    |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++---
 station.c |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 169 insertions(+), 4 deletions(-)

-- 
1.7.9.5

