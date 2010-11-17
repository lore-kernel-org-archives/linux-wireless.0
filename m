Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59775 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933263Ab0KQCDa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Nov 2010 21:03:30 -0500
Subject: Re: [PATCH] iw: Resolve namespace clash between station plink and
 vlan commands
From: Johannes Berg <johannes@sipsolutions.net>
To: Javier Cardona <javier@cozybit.com>
Cc: nbd@openwrt.org, linux-wireless@vger.kernel.org
In-Reply-To: <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
References: <1289867251-21559-1-git-send-email-javier@cozybit.com>
	 <1289946246.3673.12.camel@jlt3.sipsolutions.net>
	 <AANLkTimuW8wTVUW4dH1t+J6jhoEkFHZ7v5t78tXe050O@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 18:05:03 -0800
Message-ID: <1289959503.29119.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-11-16 at 17:41 -0800, Javier Cardona wrote:

> > I'll happily take this, but would you prefer to have the other one
> > backed out instead?
> 
> That would save us and some of our clients from having to change a
> bunch of scripts, yes.

Actually, I won't have time today, but it looks like they can be shared
in some way? Maybe by sharing the same callback function or something? I
mean -- it should be possible to do two things on set... not sure now,
I'll take a look later. Maybe you can work with an older iw version
until then?

johannes

