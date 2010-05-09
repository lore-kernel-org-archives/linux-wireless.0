Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52219 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754566Ab0EIApN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 May 2010 20:45:13 -0400
Date: Sat, 8 May 2010 20:40:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: pigiron <pigiron@gmx.com>
Cc: Javier Cardona <javier@cozybit.com>, linux-wireless@vger.kernel.org
Subject: Re: The case of the bogus SSID
Message-ID: <20100509004006.GA5790@tuxdriver.com>
References: <20100505120131.2b9f4e06@atom.pigiron.org>
 <t2j446ae9281005061112z6eee4126z673947eb02dc4f12@mail.gmail.com>
 <20100506215613.43477434@atom.pigiron.org>
 <w2r445f43ac1005070929uacb5472dj231ff72ef0343860@mail.gmail.com>
 <20100508093445.581e180e@atom.pigiron.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20100508093445.581e180e@atom.pigiron.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 08, 2010 at 09:34:45AM -0500, pigiron wrote:
> On Fri, 7 May 2010 09:29:18 -0700 Javier Cardona <javier@cozybit.com> wrote:

> > I don't know about the router, nor if the IE ID clash is causing your
> > problem, but moving the mesh codes somewhere else in the unassigned ID
> > space would be a "A Good Thing To Do (tm)".

> Really?
> 
> Wouldn't that cause a problem for the kids running OLPC? For instance, where
> some of the laptops are running an old level of code where WLAN_EID_MESH_ID=52
> and others are running new code where WLAN_EID_MESH_ID=X.

If I'm not mistaken, the mesh done in OLPC is already incompatible w/
802.11s anyway.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
