Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53070 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3CGKVW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Mar 2013 05:21:22 -0500
Message-ID: <1362651676.8694.24.camel@jlt4.sipsolutions.net> (sfid-20130307_112125_528177_F2DC6D13)
Subject: Re: [PATCH] wireless: fix inconsistency in trace for
 rdev_set_mac_acl
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 07 Mar 2013 11:21:16 +0100
In-Reply-To: <1362647309-20389-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1362647309-20389-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-03-07 at 11:08 +0200, Vladimir Kondratiev wrote:
> There is NETDEV_ENTRY that was incorrectly assigned as WIPHY_ASSIGN
> fix it

Applied.

johannes

