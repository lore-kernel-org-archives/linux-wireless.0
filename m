Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1868 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbZAYVVH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2009 16:21:07 -0500
Date: Sun, 25 Jan 2009 16:20:44 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Tulio Magno Quites Machado Filho <tuliom@gmail.com>
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Subject: Re: [ath5k-devel] [PATCH] ath5k: support LED's on emachines E510 notebok
Message-ID: <20090125212044.GA3592@hash.localnet> (sfid-20090125_222114_159897_524A682F)
References: <1232914461-19607-1-git-send-email-tuliom@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1232914461-19607-1-git-send-email-tuliom@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 25, 2009 at 09:14:21PM +0100, Tulio Magno Quites Machado Filho wrote:
> Add vendor ID for AMBIT and use it to set the ath5k LED gpio.

Thanks!

>  #define PCI_VENDOR_ID_FOXCONN		0x105b
>  
> +#define PCI_VENDOR_ID_AMBIT		0x1468
> +

Can you put the vendor id in order?  The file is supposed to be
sorted by vendor id, then by device id in order to reduce merge 
conflicts.

With that change, feel free to add my:

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com

