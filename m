Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:52228 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755685AbYBAEFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 23:05:07 -0500
Date: Thu, 31 Jan 2008 23:03:58 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: ath5k: reset for 5424-based card
Message-ID: <20080201040358.GA13428@hash.localnet> (sfid-20080201_040510_765162_F688C93A)
References: <20080131155901.GA7997@hash.localnet> <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0801310856p28513848nd22c4b3c590b7a46@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2008 at 06:56:51PM +0200, Nick Kossifidis wrote:
> Can you plz run ath_info tool found on madwifi-trace branch and post
> the output (mac/phy revision) ?

Sure -- full output is at http://bobcopeland.com/ath5k/ along with
EEPROM dump and a scan of my neighborhood.

MAC Version:  2424  (0xa0)
MAC Revision: 5424  (0xa3)
Warning: Invalid EEPROM Magic number!
Device type:  3
5Ghz PHY Revision: SChip (0xa2)
2Ghz PHY Revision: SChip (0xa2)

> so i left it for the patch series i'm working on). If you got your
> card scanning then we are really close on fixing it !

Excellent news!

> Another important question, what band was the ap on ?

Good question - it was a Starbucks hotspot so I'm guessing 802.11b?

-- 
Bob Copeland %% www.bobcopeland.com 

