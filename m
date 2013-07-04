Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab3GDHqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 03:46:42 -0400
Message-ID: <1372923998.8235.1.camel@jlt4.sipsolutions.net> (sfid-20130704_094645_821516_67FE9CB9)
Subject: Re: [PATCH V2] vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: voncken <cedric.voncken@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 04 Jul 2013 09:46:38 +0200
In-Reply-To: <00e901ce7886$ae44d360$0ace7a20$@acksys.fr>
References: <1372319520-29087-1-git-send-email-cedric.voncken@acksys.fr>
	 <070e01ce762c$24fa5ff0$6eef1fd0$@acksys.fr>
	 <00e901ce7886$ae44d360$0ace7a20$@acksys.fr>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-04 at 09:18 +0200, voncken wrote:
> If the VLAN tci is set in skb->vlan_tci use the priority field to determine
> the WMM priority.

Pinging me and resending your patch isn't going to make it more likely
that I apply it. We're in the merge window, so naturally patch
application is stalled.

johannes

