Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48210 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbcJZGZK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:25:10 -0400
Message-ID: <1477461036.4059.14.camel@sipsolutions.net> (sfid-20161026_082514_923255_BD1EE1CF)
Subject: Re: [PATCH 8/8] mac80211: Claim Fast Initial Link Setup (FILS)
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 26 Oct 2016 07:50:36 +0200
In-Reply-To: <1477435489-8555-4-git-send-email-jouni@qca.qualcomm.com>
References: <1477435489-8555-1-git-send-email-jouni@qca.qualcomm.com>
         <1477435489-8555-4-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-10-26 at 01:44 +0300, Jouni Malinen wrote:
> With the previous commits, initial FILS support is now functional in
> mac80211-based drivers for both AP and stations roles.

That's a bit misleading, I guess AP role is handled entirely in
hostapd? You documented the extended feature bit to explicitly mean
station role only :)

johannes
