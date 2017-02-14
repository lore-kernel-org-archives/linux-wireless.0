Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43578 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753652AbdBNNWN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 08:22:13 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: j@w1.fi, greearb@candelatech.com
Subject: VHT extended NSS BW support framework
Date: Tue, 14 Feb 2017 14:22:01 +0100
Message-Id: <20170214132208.8715-1-johannes@sipsolutions.net> (sfid-20170214_142611_535083_0DB7E258)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

New version - now with more parsing, and a new function to get
the NSS value for a given bandwidth/MCS combination.

It'd be good if somebody were to review this carefully, this is
a rather complex thing...

johannes
