Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37799 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753685AbaE1N4x (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 09:56:53 -0400
Message-ID: <1401285408.8146.18.camel@jlt4.sipsolutions.net> (sfid-20140528_155656_267794_61F1CE1E)
Subject: Re: [PATCH v2] mac80211: fix a memory leak on sta rate selection
 table
From: Johannes Berg <johannes@sipsolutions.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, cprevotaux@nltinc.com
Date: Wed, 28 May 2014 15:56:48 +0200
In-Reply-To: <1401222837-93492-1-git-send-email-nbd@openwrt.org>
References: <1401222837-93492-1-git-send-email-nbd@openwrt.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-05-27 at 22:33 +0200, Felix Fietkau wrote:
> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
> Reported-by: Christophe Prévotaux <cprevotaux@nltinc.com>
> Fixes: 0d528d85c5
> Cc: stable@vger.kernel.org # v3.10+

Applied, with fixes to the commit log

johannes

