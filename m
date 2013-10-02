Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35337 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752832Ab3JBJFj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Oct 2013 05:05:39 -0400
Message-ID: <1380704731.13329.11.camel@jlt4.sipsolutions.net> (sfid-20131002_110541_674413_473F72E3)
Subject: Re: [PATCH V4] cfg80211: vlan priority handling in WMM
From: Johannes Berg <johannes@sipsolutions.net>
To: cedric.voncken@acksys.fr
Cc: linux-wireless@vger.kernel.org
Date: Wed, 02 Oct 2013 11:05:31 +0200
In-Reply-To: <1377518692-30084-1-git-send-email-cedric.voncken@acksys.fr> (sfid-20130826_142554_845931_84216FA9)
References: <1377518692-30084-1-git-send-email-cedric.voncken@acksys.fr>
	 (sfid-20130826_142554_845931_84216FA9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-08-26 at 14:04 +0200, cedric.voncken@acksys.fr wrote:
> From: cedric Voncken <cedric.voncken@acksys.fr>
> 
> If the VLAN tci is set in skb->vlan_tci use the priority field to determine the WMM priority.

Applied, with a linebreak in that commit log. Your (unnecessary) resend
of this also didn't even apply because it was line-wrapped in the patch.

johannes

