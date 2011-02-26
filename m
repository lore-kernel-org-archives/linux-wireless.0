Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44949 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750785Ab1BZBdS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 20:33:18 -0500
Received: by ywj3 with SMTP id 3so667885ywj.19
        for <linux-wireless@vger.kernel.org>; Fri, 25 Feb 2011 17:33:17 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 0/5] [mac|nl]80211: SAE mesh and userspace authentication
Date: Fri, 25 Feb 2011 17:32:35 -0800
Message-Id: <1298683960-20835-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

This patch series introduces support for userspace SAE (Simultaneous
Authentication of Equals) daemons through nl80211 and mac80211. This
authentication scheme is documented in IEEE 802.11s section 8.2a.1. 

Regards,
Thomas Pedersen
cozybit, inc.

