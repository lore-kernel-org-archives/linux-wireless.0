Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:48348 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753379AbYIGL40 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Sep 2008 07:56:26 -0400
Date: Sun, 7 Sep 2008 08:56:19 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Jouni Malinen <Jouni.Malinen@Atheros.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] Ath9k: Add RF kill support.
Message-ID: <20080907115619.GA15895@khazad-dum.debian.net> (sfid-20080907_135628_753603_9B991713)
References: <20080906123842.GA27504@vasanth-lnx.users.atheros.com> <1220721347.6714.114.camel@californication> <1220721572.10102.0.camel@johannes.berg> <1220721788.10102.3.camel@johannes.berg> <1220749216.6714.122.camel@californication> <1220771824.31304.2.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1220771824.31304.2.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 07 Sep 2008, Johannes Berg wrote:
> On the other hand, if rfkill isn't optional but selected, I lose, udev
> has been so buggy that I've had to disable rfkill to avoid having it go
> into an endless loop on some rfkill (re-/de-?)registrations.

Which udev?  I am working on rfkill now, and I torture the heck out of it
with re/de/registrations, and it never went berserk on me so far...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
