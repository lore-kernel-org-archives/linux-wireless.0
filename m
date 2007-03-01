Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:52028 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965504AbXCASys (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2007 13:54:48 -0500
Message-ID: <45E72174.9060104@warmcat.com>
Date: Thu, 01 Mar 2007 18:54:44 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: move PHY things to debugfs
References: <1172774065.3381.3.camel@johannes.berg>
In-Reply-To: <1172774065.3381.3.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:

> This patch moves everything except the "sta" directory from the phy
> sysfs to phy debugfs.

Gah I was using /sys/class/ieee80211/phy<n>/device/net:<ifname> to 
discover which physical device owns which interfaces... if there isn't a 
better/official way from userspace can this maybe stay in /sys?

-Andy
