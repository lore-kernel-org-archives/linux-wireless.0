Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.177]:23154 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834AbYBYU7x (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Feb 2008 15:59:53 -0500
Received: by el-out-1112.google.com with SMTP id v27so1509336ele.23
        for <linux-wireless@vger.kernel.org>; Mon, 25 Feb 2008 12:59:49 -0800 (PST)
Subject: Re: [PATCH 01/13 v2] o11s: (nl80211/cfg80211) support for mesh
	interfaces and mesh paths
From: Luis Carlos Cobo <luisca@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1203955392.13162.111.camel@johannes.berg>
References: <47be7703.20f8720a.1044.6474@mx.google.com>
	 (sfid-20080222_071730_424685_4330467A)  <1203695866.7082.49.camel@johannes.berg>
	 (sfid-20080222_155831_933711_8528D283)  <1203955392.13162.111.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 25 Feb 2008 13:01:27 -0800
Message-Id: <1203973287.6929.82.camel@localhost> (sfid-20080225_205957_377134_BCE1C3F8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-02-25 at 17:03 +0100, Johannes Berg wrote:
> Can you do that in both nl80211 and mac80211 for both STAs and paths?
> Look at net/netlink/genetlink.c ctrl_dumpfamily() for an example.

Ok, no problem.

-- 
Luis Carlos Cobo Rus       GnuPG ID: 44019B60
cozybit Inc.


