Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:37689 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbYLQLVE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 06:21:04 -0500
Message-ID: <4772.194.45.26.221.1229512858.squirrel@webmail.madwifi-project.org> (sfid-20081217_122109_525243_08BEA360)
In-Reply-To: <e27b78a40812170256o6949875dq9849f1a838f68ce2@mail.gmail.com>
References: <e27b78a40812160405h2241e1acqa0dc8e593d6ebfad@mail.gmail.com>
    <4947ABAF.9060205@cortland.com>
    <e27b78a40812160807j7549e1a5hf3bee474b31c29b7@mail.gmail.com>
    <45e8e6c40812161030x1f7fb374qd4a386ef9022a853@mail.gmail.com>
    <e27b78a40812170256o6949875dq9849f1a838f68ce2@mail.gmail.com>
Date: Wed, 17 Dec 2008 12:20:58 +0100 (CET)
Subject: Re: Mesh now completely broken on ath5k, latest git
From: "Michael Renzmann" <mrenzmann@madwifi-project.org>
To: "Keir" <keirlawson@gmail.com>
Cc: "Andrey Yurovsky" <andrey@cozybit.com>, sbrown@cortland.com,
	linux-wireless@vger.kernel.org, javier@cozybit.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

Keir wrote:
> I'm using Netgear WG311TGE PCI cards,

Those models I know of this card are just PCI-to-MiniPCI carrier cards, 
with a MiniPCI card sitting inside the metal shield. Very likely Netgear
just attached a single pigtail (which then allows to attach an antenna
from the outside of the PC case) to one of the antenna connectors on that
MiniPCI card and left the other(s) empty.

Bye, Mike
