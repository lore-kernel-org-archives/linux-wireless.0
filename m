Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40588 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751505AbdDHUYj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 8 Apr 2017 16:24:39 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: pablo@netfilter.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Benc <jbenc@redhat.com>,
        David Ahern <dsa@cumulusnetworks.com>, jiri@resnulli.us
Subject: [PATCH v3 0/5] netlink extended ACK reporting
Date: Sat,  8 Apr 2017 22:24:29 +0200
Message-Id: <20170408202434.12018-1-johannes@sipsolutions.net> (sfid-20170408_222445_881710_20CEB84F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Changes since v2:
 * add NUM_NLMSGERR_ATTRS, NLMSGERR_ATTR_MAX
 * fix cookie length to 20 (sha-1 length)
 * move struct members for cookie to patch 3 where they should be
 * another cleanup suggested by David Ahern

johannes
