Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:47993 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752518AbZAUHDQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 02:03:16 -0500
Message-ID: <1603.217.24.1.229.1232521394.squirrel@webmail.otaku42.de> (sfid-20090121_080327_129725_D1828C1B)
In-Reply-To: <9664a4720901202016o3776205fk2a8bec6bb1331c90@mail.gmail.com>
References: <9664a4720901201133g5671c7f0x718c4bd187b1d901@mail.gmail.com>
    <20090120200802.GF19581@tesla>
    <9664a4720901202016o3776205fk2a8bec6bb1331c90@mail.gmail.com>
Date: Wed, 21 Jan 2009 08:03:14 +0100 (CET)
Subject: Re: Atheros (madwifi/ath5k) virtual STA support
From: "Michael Renzmann" <mrenzmann@madwifi-project.org>
To: "Catalin Patulea" <cat@vv.carleton.ca>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Catalin Patulea wrote:
> Also, I was under the impression that ath9k is only meant for
> 802.11n chipsets (as opposed to abg), and therefore that AR5414 would
> not be supported. What am I missing?

ath9k is for Atheros' 11n chipsets, that's true. However, if Luis says
that they are working on such a feature for ath9k, one can expect that
this work will include patches for mac80211 which then other drivers can
rely on to implement a similar feature.

Bye, Mike
