Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:49573 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdEPJpJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 05:45:09 -0400
Date: Tue, 16 May 2017 11:44:04 +0200
From: Bastian Bittorf <bb@npl.de>
To: Simon Wunderlich <sw@simonwunderlich.de>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
        benjamin@sipsolutions.net
Subject: Re: [PATCH 0/7] extend mac80211 mesh DFS and CSA functionality
Message-ID: <20170516094403.GX18518@medion.lan> (sfid-20170516_114514_126586_7056B751)
References: <20170516092316.15636-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170516092316.15636-1-sw@simonwunderlich.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Simon Wunderlich <sw@simonwunderlich.de> [16.05.2017 11:35]:
> This patchset adds DFS and CSA functionality:

thanks a lot. can you give a brief 'iw event' output when applied:
for a two-node mesh, where station A detects CSA and station B
should emit an event...

question: there is no userspace part for now, or maybe planned?

bye, bastian - now it's time for battlemesh.org 8-)
