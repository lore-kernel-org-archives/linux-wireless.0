Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52257 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973Ab0C2NJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Mar 2010 09:09:17 -0400
Subject: Re: iw station del broken?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco.porsch@siemens.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4BB0A5B1.9090003@siemens.com>
References: <4BB0A16A.7080400@siemens.com>
	 <1269867487.4131.28.camel@jlt3.sipsolutions.net>
	 <4BB0A5B1.9090003@siemens.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 15:09:15 +0200
Message-ID: <1269868155.4131.29.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-03-29 at 15:05 +0200, Marco Porsch wrote:
> Johannes Berg schrieb:
> > On Mon, 2010-03-29 at 14:47 +0200, Marco Porsch wrote:
> >   
> >> Hi list,
> >>
> >> is it just me or is 'iw dev <devname> station del <MAC address>' broken?
> >>     
> >
> > No ... we decided a while ago that station manipulation in mesh was too
> > hard to support and removed it.
> >
> > What's the use case anyway?
> >
> > johannes
> >   
> The use case is that, if I have some mesh points in a single room or one 
> a small floor, I can simply give them a topology by removing the links 
> between the STA, I do not wish to be directly connected.
> Removing the links means 'iw dev <devname> set mesh_param 
> mesh_auto_open_plinks 0', which blocks building up new peering links, 
> and then removing some links with 'station del'.

Can't you just do that before it gets discovered?

I'm not really happy with the mesh API anyway ...

johannes

