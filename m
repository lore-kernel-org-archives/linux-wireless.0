Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:53863 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab3GEJ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Jul 2013 05:57:18 -0400
Message-ID: <1373018235.8548.4.camel@jlt4.sipsolutions.net> (sfid-20130705_115720_990474_C8EC87BD)
Subject: Re: [PATCH V2] vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric.voncken@acksys.fr
Cc: linux-wireless@vger.kernel.org
Date: Fri, 05 Jul 2013 11:57:15 +0200
In-Reply-To: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Subject line should have a "wireless: " (or "cfg80211: ") prefix.

> If the VLAN tci is set in skb->vlan_tci use the priority field to determine the WMM priority.
> 
> V2 modifications :
> 	Fix indentation
> 	Use symbolic constant
> 	include the header linux/if_vlan.h

This doesn't belong into the changelog, it should be after --- with the
diffstat.

johannes

