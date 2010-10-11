Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58899 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0JKR6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 13:58:49 -0400
Subject: Re: [PATCH] wireless:  Print wiphy name in sysfs.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1286818139-1746-1-git-send-email-greearb@candelatech.com>
References: <1286818139-1746-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 19:58:47 +0200
Message-ID: <1286819927.3634.79.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-10-11 at 10:28 -0700, greearb@candelatech.com wrote:

> The index cannot be used to reliably reconstruct a phy
> name, so explicitly add the phy name to sysfs so that scripts
> can figure out the parent phy device for a particular
> wireless interface.

But you still need to know the name to get at this to start with, so
what's the point?

cat /sys/class/ieee80211/<phyname>/name
<phyname>

or

cat /sys/devices/pci0000:00/0000:00:15.0/0000:03:00.0/ssb0:0/ieee80211/phy0/name
phy0

johannes

