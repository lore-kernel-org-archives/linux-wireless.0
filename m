Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42500 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754019AbdBHJrT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 04:47:19 -0500
Message-ID: <1486547234.24745.0.camel@sipsolutions.net> (sfid-20170208_104859_249231_FD2A7ED7)
Subject: Re: [PATCH v4 2/5] cfg80211: Pass new RSSI level in CQM RSSI
 notification
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date: Wed, 08 Feb 2017 10:47:14 +0100
In-Reply-To: <20170125114344.8179-2-andrew.zaborowski@intel.com> (sfid-20170125_124406_676314_6B2FAD43)
References: <20170125114344.8179-1-andrew.zaborowski@intel.com>
         <20170125114344.8179-2-andrew.zaborowski@intel.com>
         (sfid-20170125_124406_676314_6B2FAD43)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, I've applied patches 1-2 right now, that really makes sense
regardless of the others.

johannes
