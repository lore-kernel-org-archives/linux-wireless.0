Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2447 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852AbZKGMoQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Nov 2009 07:44:16 -0500
Date: Sat, 7 Nov 2009 07:43:36 -0500
From: Bob Copeland <me@bobcopeland.com>
To: David Dreggors <ddreggors@jumptv.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, ddreggors@cfl.rr.com
Subject: Re: [PATCH] This adds support for the wifi led on the Compaq
	CQ60-206US.
Message-ID: <20091107124336.GA20330@hash.localnet>
References: <1257580711.23806.84.camel@mobile-tek.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1257580711.23806.84.camel@mobile-tek.home>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Nov 07, 2009 at 02:58:31AM -0500, David Dreggors wrote:
>         ATH_LED(1, 1) },
>         +       /* HP Compaq CQ60-206US */
>         +       { ATH_SDEVICE(PCI_VENDOR_ID_HP, 0x137a), ATH_LED(3,
>         1) },


Thanks.  This patch is wrapped in a very strange way, and needs a
contact address and signed-off-by -- but I'm submitting some patches
today so if you like I'll just redo it and add your reported-by.

-- 
Bob Copeland %% www.bobcopeland.com

