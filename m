Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:40852 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0LJXEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Dec 2010 18:04:24 -0500
Received: by yxt3 with SMTP id 3so2378551yxt.19
        for <linux-wireless@vger.kernel.org>; Fri, 10 Dec 2010 15:04:24 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2] mac80211/open80211s: Support alternative path selection algorithms
Date: Fri, 10 Dec 2010 15:04:09 -0800
Message-Id: <1292022251-12616-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These patches add support for implementing alternative path selection
algorithms from userspace. 

