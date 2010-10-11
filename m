Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44441 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755416Ab0JKSKC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 14:10:02 -0400
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4CB351B2.4070803@candelatech.com>
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com>
	 <1286819927.3634.79.camel@jlt3.sipsolutions.net>
	 <4CB351B2.4070803@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 20:10:00 +0200
Message-ID: <1286820600.3634.80.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 11:04 -0700, Ben Greear wrote:


> I use this to determine the phy device for a particular network device:
> 
> [root@dx-2u-ath5k lanforge]# cat /sys/class/net/wlan0/phy80211/name
> wiphy0

What's wrong with

basename $(readlink /sys/class/net/wlan0/phy80211)

?

johannes

