Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2084 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362AbZCRAGz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 20:06:55 -0400
Date: Tue, 17 Mar 2009 20:06:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Xose Vazquez Perez <xose.vazquez@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	David Quan <David.Quan@Atheros.com>
Subject: Re: ids missing in ath5k ?
Message-ID: <20090318000650.GD18141@hash.localnet> (sfid-20090318_010711_860034_5CDBE920)
References: <49BC0DBE.90209@gmail.com> <49BC6C21.6020807@gmail.com> <49BC7117.1010107@gmail.com> <b6c5339f0903171418h6534a5a8w1ef8354f9571657a@mail.gmail.com> <20090317213639.GF6061@tesla> <20090317223632.GN6061@tesla>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090317223632.GN6061@tesla>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2009 at 03:36:32PM -0700, Luis R. Rodriguez wrote:
> > ACK on FF1A -- 802.11abg, NACK on the others, we don't at least have
> > them in our own windows driver INF file.
> 
> Actually so any 0xFF1x device ID where x is any value would
> be the ID if the card has issues reading our EEPROM and in that
> case you can expect the card to simply not be operational, so feel
> free to add it but be sure to inform the user the card is having
> issues reading the EEPROM and simply disable the device.

In light of that, I'm inclined to just leave it alone then unless 
someone appears with such IDs.

-- 
Bob Copeland %% www.bobcopeland.com

