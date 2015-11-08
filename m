Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33022 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbbKHXxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Nov 2015 18:53:35 -0500
Received: by qgea14 with SMTP id a14so49627408qge.0
        for <linux-wireless@vger.kernel.org>; Sun, 08 Nov 2015 15:53:35 -0800 (PST)
Date: Sun, 8 Nov 2015 18:53:24 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [PATCH] mac80211: mesh: print MAC address instead of pointer
Message-ID: <20151108235324.GB30106@localhost> (sfid-20151109_005350_069904_EEED65F8)
References: <1446805846-5210-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1446805846-5210-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 06, 2015 at 11:30:46AM +0100, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> There's no point in printing the mpath pointer since it can't
> be used for anything - print the MAC address instead (like in
> the forwarding case.)
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

FWIW:

Acked-by: Bob Copeland <me@bobcopeland.com>

>  			mpath_dbg(sdata,
> -				  "Not forwarding %p (flags %#x)\n",
> -				  gate->mpath, gate->mpath->flags);
> +				  "Not forwarding to %pM (flags %#x)\n",
> +				  gate->mpath->dst, gate->mpath->flags);

-- 
Bob Copeland %% http://bobcopeland.com/
