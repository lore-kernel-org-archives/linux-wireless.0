Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:54391 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753111Ab2AWLUf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jan 2012 06:20:35 -0500
Date: Mon, 23 Jan 2012 13:20:26 +0200
From: Johan Hedberg <johan.hedberg@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH COMMITTED] bluetooth: hci: Fix type of "enable_hs" to
 bool.
Message-ID: <20120123112026.GA18050@x220> (sfid-20120123_122050_816068_D061DA53)
References: <20120122.144654.2252112633629547845.davem@davemloft.net>
 <1327283783.1955.84.camel@aeonflux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1327283783.1955.84.camel@aeonflux>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Marcel,

On Mon, Jan 23, 2012, Marcel Holtmann wrote:
> Hi Dave,
> 
> > net/bluetooth/hci_core.c: In function ‘__check_enable_hs’:
> > net/bluetooth/hci_core.c:2587:1: warning: return from incompatible pointer type [enabled by default]
> > 
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> > ---
> > 
> > I noticed this while validating the build today, committed to 'net'.
> 
> and from your subject, I assume you rightfully just applied that patch
> to your tree.
> 
> I remember that I acked such a patch, but it seems it never made it
> anywhere in the end :(

It's over here:

http://git.kernel.org/?p=linux/kernel/git/jh/bluetooth-next.git;a=commitdiff;h=174b9000541fdffbdc53cf9464efb1c8a1d777db

Johan
