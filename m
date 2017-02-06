Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35950 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751299AbdBFHAv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 6 Feb 2017 02:00:51 -0500
Message-ID: <1486364443.14226.4.camel@sipsolutions.net> (sfid-20170206_080125_637129_07631148)
Subject: Re: [PATCH] nl80211: Fix mesh HT operation check
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 06 Feb 2017 08:00:43 +0100
In-Reply-To: <1485388573-4264-1-git-send-email-masashi.honma@gmail.com> (sfid-20170126_005626_612572_27CA0ED2)
References: <1485388573-4264-1-git-send-email-masashi.honma@gmail.com>
         (sfid-20170126_005626_612572_27CA0ED2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-01-26 at 08:56 +0900, Masashi Honma wrote:
> commit 9757235f451c27deaa88925399f070ff6fcea832 ('nl80211: correct
> checks for NL80211_MESHCONF_HT_OPMODE value') missed to mask a flag
> when replacing FILL_IN_MESH_PARAM_IF_SET with checking codes. This
> could drop the received HT operation value when called by
> nl80211_update_mesh_config().

Applied, thanks.

johannes
