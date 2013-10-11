Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55694 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753372Ab3JKV3S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Oct 2013 17:29:18 -0400
Message-ID: <52586DA9.5050204@openwrt.org> (sfid-20131011_232928_874772_026F149F)
Date: Fri, 11 Oct 2013 23:29:13 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: greearb@candelatech.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211:  Add rate-control name to station debugfs.
References: <1381525471-23655-1-git-send-email-greearb@candelatech.com>
In-Reply-To: <1381525471-23655-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-10-11 11:04 PM, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Nice to see what algorithm it's actually using.
No need for that, you can use this:
# cat /sys/kernel/debug/ieee80211/phy0/rc/name

- Felix

