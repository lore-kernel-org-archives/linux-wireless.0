Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57521 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab1FFM1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 08:27:49 -0400
Received: by vxi39 with SMTP id 39so2683152vxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 05:27:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 6 Jun 2011 14:27:48 +0200
Message-ID: <BANLkTim1Z2_GSOgN054Uh39da5s2YYpd7Q@mail.gmail.com> (sfid-20110606_142752_681802_2FDF02ED)
Subject: cfg80211_registered_device question
From: Daniele Furlan <daniele.furlan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Why struct cfg80211_registered_device is defined in
/net/wireless/core.h and not in /include/net/cfg80211.h ?

In this way there isn't the possibility from kernel space to use this
struct to access cfg80211_ops.

-- 
Daniele Furlan
