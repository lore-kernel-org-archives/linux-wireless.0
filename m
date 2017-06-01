Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59418 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751155AbdFASXb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Jun 2017 14:23:31 -0400
Message-ID: <1496341408.4086.0.camel@sipsolutions.net> (sfid-20170601_202334_602781_A4512BE4)
Subject: Re: Fw: [Bug 195953] New: Possible access to unintended variable in
 "linux/net/mac80211/sta_info.c" line 2158
From: Johannes Berg <johannes@sipsolutions.net>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 01 Jun 2017 20:23:28 +0200
In-Reply-To: <20170601110701.21dcef2a@xeon-e3> (sfid-20170601_200709_868987_9FAEDD95)
References: <20170601110701.21dcef2a@xeon-e3>
         (sfid-20170601_200709_868987_9FAEDD95)
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Stephen, I'll take the bug and fix it.

johannes
