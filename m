Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2028 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbZBFDwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 22:52:38 -0500
Date: Thu, 5 Feb 2009 22:52:14 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 5/5] ath5k: Update reset code
Message-ID: <20090206035214.GB10581@hash.localnet> (sfid-20090206_045249_990860_FF115B44)
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis> <20090205154532.M30551@bobcopeland.com> <40f31dec0902051306m769712ecn858672ba24524c63@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0902051306m769712ecn858672ba24524c63@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 05, 2009 at 11:06:59PM +0200, Nick Kossifidis wrote:
> I think this is because we call reset too many times. Try removing
> call to reset from config_interface, after some tests i did it seems

Ok I'll try it, let you know ASAP.

-- 
Bob Copeland %% www.bobcopeland.com

