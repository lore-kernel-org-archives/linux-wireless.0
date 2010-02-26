Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ist.d-labs.de ([213.239.218.44]:33357 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933907Ab0BZLBw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Feb 2010 06:01:52 -0500
From: florian@mickler.org
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Randy Dunlap" <rdunlap@xenotime.net>,
	"Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	"Greg Kroah-Hartman" <gregkh@suse.de>,
	Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH v2 2/2] enhance sysfs rfkill interface
Date: Fri, 26 Feb 2010 12:01:33 +0100
Message-Id: <1267182094-15469-1-git-send-email-florian@mickler.org>
In-Reply-To: <20100225233516.GD5218@khazad-dum.debian.net>
References: <20100225233516.GD5218@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Thu, 25 Feb 2010 20:35:16 -0300
Henrique de Moraes Holschuh <hmh@hmh.eng.br> wrote:

> On Wed, 24 Feb 2010, florian@mickler.org wrote:  
> > I am not shure about those names.  
> 
> I don't like them.  IMHO, you don't gain anything by being this terse, and
> it is difficult to understand what they mean at first glance.
>   
> > Other alternatives: 
> > [hs]w_block
> > block_[hs]w  
> 

I made that blocked_sw and blocked_hw, so that they are
lexicographically nearby and that they also give more information about
their content.

blocked_[hs]w -> 0/1 makes IMO kind of sense.

cheers,
Flo
