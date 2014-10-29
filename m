Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38724 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933329AbaJ2PtB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 11:49:01 -0400
Message-ID: <1414597738.1827.15.camel@jlt4.sipsolutions.net> (sfid-20141029_164908_475704_85A949DE)
Subject: Re: [PATCH 1/3] mac80211-hwsim: Rename CREATE and DESTROY radio to
 NEW and DEL radio
From: Johannes Berg <johannes@sipsolutions.net>
To: Jukka Rissanen <jukka.rissanen@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 29 Oct 2014 16:48:58 +0100
In-Reply-To: <1414406688-3827-2-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141027_114542_004307_3D71781D)
References: <1414406688-3827-1-git-send-email-jukka.rissanen@linux.intel.com>
	 <1414406688-3827-2-git-send-email-jukka.rissanen@linux.intel.com>
	 (sfid-20141027_114542_004307_3D71781D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-10-27 at 12:44 +0200, Jukka Rissanen wrote:
> Using the name HWSIM_CMD_NEW_RADIO and HWSIM_CMD_DEL_RADIO is more
> fitting on how other pieces of the wireless system work.

Applied.

johannes

