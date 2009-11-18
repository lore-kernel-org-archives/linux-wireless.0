Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44421 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968AbZKRDDR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 22:03:17 -0500
Date: Tue, 17 Nov 2009 21:59:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Stefan Monnier <monnier@iro.umontreal.ca>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC v2] mac80211: disallow bridging managed/adhoc interfaces
Message-ID: <20091118025920.GA4588@tuxdriver.com>
References: <1258465585.3682.7.camel@johannes.local> <1258490898.21197.42.camel@johannes.local> <jwvy6m4bnqp.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <jwvy6m4bnqp.fsf-monnier+gmane.linux.kernel.wireless.general@gnu.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 17, 2009 at 08:59:03PM -0500, Stefan Monnier wrote:
> > A number of people have tried to add a wireless interface
> > (in managed mode) to a bridge and then complained that it
> > doesn't work. It cannot work, however, because in 802.11
> [...]
> > To avoid such mistakes in the future, disallow adding a
> > wireless interface to a bridge.
> 
> As someone who's been bitten by this, I fully support this change.
> Still, it makes me wonder: my broadcom-based home-router using the wl.o
> driver can be set in "client bridge" mode.  How does it work?

If I'm not mistaken, that has a bunch of code embedded in it that
among other things can do a layer-2 version of NAT to rewrite the
MAC adresses for frames on the air.

YMMV...

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
