Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35811 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752510Ab0L1XBt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 18:01:49 -0500
Received: by pzk35 with SMTP id 35so714063pzk.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 15:01:48 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Cc: mwl8k-devel@cozybit.com, buytenh@wantstofly.org
Subject: [PATCH 0/4] mwl8k: Add HW crypto support for AP mode
Date: Tue, 28 Dec 2010 15:01:33 -0800
Message-Id: <1293577297-25755-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

These patches add support for HW crypto using the mwl8k driver when AP firmware
is loaded. The driver currently falls back to SW crypto in mac80211 when in STA
mode, but a future patch will address this. Crypto while an AP and STA both
appear to work fine. 

Thomas

