Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:29563 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751756Ab0ETFgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 May 2010 01:36:23 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0196543778
	for <linux-wireless@vger.kernel.org>; Thu, 20 May 2010 14:36:19 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [ath5k-devel] [PATCH v2 13/20] cfg80211: Add nl80211 antenna configuration
Date: Thu, 20 May 2010 14:36:11 +0900
References: <20100519012528.22206.77550.stgit@tt-desk> <201005201121.49846.br1@einfach.org> <AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
In-Reply-To: <AANLkTilG3c2UDEQa66PMvKysRVTt_dd-ZAS8FiDOe4Ob@mail.gmail.com>
Cc: "ath5k-devel@lists.ath5k.org" <ath5k-devel@lists.ath5k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201005201436.11667.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 May 2010 14:17:19 you wrote:
> None of the legacy 802.11 drivers we support have more than 2
> antennas, I am also not aware of any.

i have heard of some solutions based on atheros chipsets with more than 2 
antennas ("pre-11n RangeMax", "large phased array switch"). please check 
internally.

> But -- I can think of using an 802.11n device in legacy
> mode of operation using specific antennas.... so there's your example
> of a valid case for this.

thanks! :)

> Legacy devices are dead. I don't know anyone in the industry making
> them, the 1 stream 802.11n devices are cheaper today, so there is no
> point in the market for it.

that might be true from a chipset manufacturers marketing perspective - but we 
work on the linux kernel... ;)

as you know there are millions of so called "legacy" chipsets out there and 
people are going to continue to use them wether your marketing declares them 
"dead" or not... i think it's worth to properly support them.

also please don't forget that some people use the linux kernel not just for  
standard use cases, but for research and developing new solutions. we should 
provide the flexibility to support that, if possible.

> > and we are sure we don't want to support more than 2
> > antennas - well, we could save 6 bits... is it really worth it?
> 
> You're right, then if you really don't mind lets think 802.11n through
> well then.

i don't mind to do that, but as i said i dont know much about 802.11n yet.

bruno
