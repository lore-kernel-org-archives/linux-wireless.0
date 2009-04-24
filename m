Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4422 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769AbZDXECe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Apr 2009 00:02:34 -0400
Date: Fri, 24 Apr 2009 00:01:43 -0400
From: Bob Copeland <me@bobcopeland.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com, mcgrof@gmail.com,
	nbd@openwrt.org
Subject: Re: [PATCH 1/7] ath5k: Allow user/driver to set txpower
Message-ID: <20090424040143.GB3277@hash.localnet> (sfid-20090424_060241_040303_29709643)
References: <20090416002220.GA4138@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090416002220.GA4138@makis>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2009 at 03:22:20AM +0300, Nick Kossifidis wrote:
>  * Now that we have regulatory control enable the driver to set txpower on hw
>  * Also use txpower table offset so that we can match power range set by user/driver with indices on power table.

BTW I gave this patchset a spin on my rf 5413 and it works fine here, 
so feel free to add my Acked-By on the series.  Does it need anything
besides a reposting with 72-col changelogs?

-- 
Bob Copeland %% www.bobcopeland.com

