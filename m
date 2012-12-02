Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41340 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752879Ab2LBMil (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Dec 2012 07:38:41 -0500
Message-ID: <50BB4BC5.1010806@openwrt.org> (sfid-20121202_133901_685856_3256407B)
Date: Sun, 02 Dec 2012 13:38:29 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Saravana <saravanad@posedge.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add debugfs file for last rx rate
References: <50B77013.6040508@posedge.com>
In-Reply-To: <50B77013.6040508@posedge.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-11-29 3:24 PM, Saravana wrote:
> Add a debugfs file showing the rate at which
> the last packet is received.
> 
> Signed-off-by: Saravana <saravanad@posedge.com>
What's the point of adding debugfs files for data which is already
available via nl80211?

- Felix
