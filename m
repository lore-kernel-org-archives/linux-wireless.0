Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1060 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757693AbZDSOnI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Apr 2009 10:43:08 -0400
Date: Sun, 19 Apr 2009 10:42:16 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org, j@w1.fi
Subject: Re: [PATCH 5/7] ath5k: Enable AP mode
Message-ID: <20090419144216.GB866@hash.localnet> (sfid-20090419_164312_294511_564137D3)
References: <20090416003604.GE4138@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090416003604.GE4138@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 03:36:04AM +0300, Nick Kossifidis wrote:
>  Author: Jiri Slaby (Jiri added AP support on ath5k, i'm just setting the flag here)

Should do this like:

From: Jiri Slaby <...>

Then git-am will pick it up automatically.

> +		BIT(NL80211_IFTYPE_AP) |

Yay!  

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

