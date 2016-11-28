Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43144 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932283AbcK1ORp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Nov 2016 09:17:45 -0500
Message-ID: <1480342662.8107.42.camel@sipsolutions.net> (sfid-20161128_151748_192277_352EB28D)
Subject: Re: [PATCH 2/2] cfg80211: Add support to sched scan to report
 better BSSs
From: Johannes Berg <johannes@sipsolutions.net>
To: Jouni Malinen <jouni@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
        vamsi krishna <vamsin@qti.qualcomm.com>
Date: Mon, 28 Nov 2016 15:17:42 +0100
In-Reply-To: <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
References: <1479938857-1788-1-git-send-email-jouni@qca.qualcomm.com>
         <1479938857-1788-2-git-send-email-jouni@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-11-24 at 00:07 +0200, Jouni Malinen wrote:
> 
> +	int bbr;

bbr? Also, bool?
 
johannes
