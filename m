Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:52121 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751943AbXDFTbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Apr 2007 15:31:38 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HZu7Z-0002UN-VJ
	for linux-wireless@vger.kernel.org; Fri, 06 Apr 2007 15:29:18 -0400
Subject: Re: Orinoco, mac80211 and wpa2
From: Pavel Roskin <proski@gnu.org>
To: Erik Mouw <mouw@nl.linux.org>
Cc: Jouni Malinen <jkm@devicescape.com>,
	Dan Williams <dcbw@redhat.com>, Jan Dittmer <jdi@l4x.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070406100328.GA3126@gateway.home>
References: <4613A4A9.1060902@l4x.org>
	 <1175697737.2656.3.camel@localhost.localdomain>
	 <1175700158.5322.9.camel@dv> <20070404153814.GC8229@devicescape.com>
	 <1175703938.5322.21.camel@dv>  <20070406100328.GA3126@gateway.home>
Content-Type: text/plain
Date: Fri, 06 Apr 2007 15:31:26 -0400
Message-Id: <1175887886.28918.16.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-04-06 at 12:03 +0200, Erik Mouw wrote:
> > Since Orinoco 9.xx firmware has explicit support for WPA (at least for
> > TKIP), I guess it could be used for that with or without mac80211.
> 
> Do you have any idea where I can find 9.xx firmware? The latest
> firmware I can find for Orinoco PCMCIA Silver/Gold is 8.72.

It's in wl_lkm_718_abg.tar.gz, which was sadly taken offline by Agere.

I could find a copy here:
http://www.elcard.fi/Driver/wl_lkm_718_release.tar.gz.tar

The file is misnamed, it should be renamed to wl_lkm_718_abg.tar.gz

The firmware for Orinoco cards is in "firmware" directory.  It's version
9.48.  I believe it's RAM loadable and cannot be flashed permanently.

-- 
Regards,
Pavel Roskin

