Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42779 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1HJNsB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Aug 2011 09:48:01 -0400
Subject: Re: [PATCH 8/8] {nl,cfg,mac}80211: let userspace make meshif mesh
 gate
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org,
	Javier Cardona <javier@cozybit.com>, linville@tuxdriver.com
In-Reply-To: <1312933511-9486-9-git-send-email-thomas@cozybit.com> (sfid-20110810_014706_804427_DAE2F672)
References: <1312933511-9486-1-git-send-email-thomas@cozybit.com>
	 <1312933511-9486-9-git-send-email-thomas@cozybit.com>
	 (sfid-20110810_014706_804427_DAE2F672)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 10 Aug 2011 15:47:58 +0200
Message-ID: <1312984078.4325.5.camel@jlt3.sipsolutions.net> (sfid-20110810_154807_487536_3627F6DE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-08-09 at 16:45 -0700, Thomas Pedersen wrote:
> From: Javier Cardona <javier@cozybit.com>
> 
> Allow userspace to set NL80211_MESHCONF_GATE_ANNOUNCEMENTS attribute,
> which will advertise this mesh node as being a mesh gate.
> NL80211_HWMP_ROOTMODE must be set or this will do nothing.

IMHO it should be rejected instead of doing nothing.

johannes

