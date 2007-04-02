Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dhost002-38.dex002.intermedia.net ([64.78.21.123]:44846 "EHLO
	dhost002-38.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933686AbXDBRBb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Apr 2007 13:01:31 -0400
From: "Jouni Malinen" <jkm@devicescape.com>
Date: Mon, 2 Apr 2007 10:01:30 -0700
To: Joerg Mayer <jmayer@loplof.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: SIOCSIWAP behavior question
Message-ID: <20070402170130.GC2706@devicescape.com>
References: <1175521655.9859.15.camel@localhost.localdomain> <20070402155405.GA2706@devicescape.com> <20070402165643.GH10005@thot.informatik.uni-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20070402165643.GH10005@thot.informatik.uni-kl.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 02, 2007 at 06:56:43PM +0200, Joerg Mayer wrote:
> On Mon, Apr 02, 2007 at 08:54:05AM -0700, Jouni Malinen wrote:
> > I would ike to see disconnect event only if the driver/stack notices
> > that it cannot complete association and based on this, believes its
> > association to the ESS is lost.
> 
> What is the recommended way to cause a disconnect / reconnect?

I don't know whether there is such a thing, but I normally use
SIOCSIWESSID with a different SSID (e.g., a random string) to force
disconnection and with the same SSID to force re-association to the same
ESS.

-- 
Jouni Malinen                                            PGP id EFC895FA
