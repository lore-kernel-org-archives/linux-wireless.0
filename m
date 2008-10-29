Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1678 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbYJ2CqV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 22:46:21 -0400
Date: Tue, 28 Oct 2008 22:46:03 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH] ath5k: Update PCU code
Message-ID: <20081029024603.GA22759@hash.localnet> (sfid-20081029_034625_602601_956827FC)
References: <20081029021121.GA3079@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081029021121.GA3079@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 04:11:22AM +0200, Nick Kossifidis wrote:
>  * Properly clean MIC key from keytable when TKIP is used (Bob is
>  working on set_key function etc so i leave it for now).

Heh, I was just prepping patches to send out.  I had basically the
same thing for _reset_key too so I'll just rebase mine on top of this.

-- 
Bob Copeland %% www.bobcopeland.com

