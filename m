Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50264 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932708AbcLMPgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Dec 2016 10:36:54 -0500
Message-ID: <1481643411.20412.10.camel@sipsolutions.net> (sfid-20161213_163657_402350_D84872EA)
Subject: Re: [PATCH v3] cfg80211: NL80211_ATTR_SOCKET_OWNER support for
 CMD_CONNECT
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 13 Dec 2016 16:36:51 +0100
In-Reply-To: <1481643200.20412.9.camel@sipsolutions.net> (sfid-20161213_163352_624423_62A8C3DA)
References: <20161212164500.691-1-andrew.zaborowski@intel.com>
         (sfid-20161212_174513_083117_405C8DC6) <1481643200.20412.9.camel@sipsolutions.net>
         (sfid-20161213_163352_624423_62A8C3DA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> All the code you added to nl80211.c is racy.

Maybe it's not? But that'd be hard to reason about, having to look into
af_netlink.c and all, so it's easier to just make it not appear racy
here.

johannes
