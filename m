Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36728 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdGGJ16 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 7 Jul 2017 05:27:58 -0400
Message-ID: <1499419676.4790.1.camel@sipsolutions.net> (sfid-20170707_112802_063687_F73C2F00)
Subject: Re: [PATCH 1/4] cfg80211: Check if PMKID attribute is of expected
 size
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        Srinivas Dasari <dasaris@qti.qualcomm.com>
Date: Fri, 07 Jul 2017 11:27:56 +0200
In-Reply-To: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
References: <1499381022-5389-1-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All applied, thanks.

How did you find these? Some of them go way back, after all, and I
don't think even coverity flagged them?

johannes
