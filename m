Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34910 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751704AbcLGJZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 04:25:30 -0500
Message-ID: <1481102727.4092.34.camel@sipsolutions.net> (sfid-20161207_102533_102224_A613ED54)
Subject: Re: [PATCH v2 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Wed, 07 Dec 2016 10:25:27 +0100
In-Reply-To: <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
References: <1480715949-20169-1-git-send-email-jouni@qca.qualcomm.com>
         <1480715949-20169-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> v2: address comments from Luca, Arend, and Johannes

What about Arend's comment regarding this functionality overlapping
with the BSS selection offload configuration?

Do you think there's any ability to share attributes/functionality?

johannes
