Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZGUUKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jul 2009 16:10:45 -0400
Subject: Re: [PATCH 3/3] MAINTAINERS: add wl1251 wireless driver
From: reinette chatre <reinette.chatre@intel.com>
To: Joe Perches <joe@perches.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"jirislaby@gmail.com" <jirislaby@gmail.com>,
	"luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	James Ketrenos <jketreno@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <1248206362.31365.292.camel@Joe-Laptop.home>
References: <20090721191136.22374.69017.stgit@tikku>
	 <20090721191154.22374.17349.stgit@tikku>
	 <1248204540.31365.275.camel@Joe-Laptop.home>
	 <87ocrdsu9f.fsf@litku.valot.fi>
	 <1248206362.31365.292.camel@Joe-Laptop.home>
Content-Type: text/plain
Date: Tue, 21 Jul 2009 13:10:45 -0700
Message-Id: <1248207045.17896.2695.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-07-21 at 12:59 -0700, Joe Perches wrote:
> On Tue, 2009-07-21 at 22:36 +0300, Kalle Valo wrote:
> > Also in the future we might share some of the code between
> > 1251 and 1271. Any tips for this?
> 
> Sorry, no.
> 
> There are a couple of examples of multiple maintainers
> for wireless drivers in a single directory.
> 
> ipw2x00 and rtl818x
> 
> ipw2xx has shared files, rtl818x does not.
> ipw2xx does not claim a "maintainer" for the
> shared files.  That's probably not important.
> 
> Maybe the maintainers for ipw2xx might give
> some more useful information (cc'd). It turns
> out they are the same people though.

I do not have anything useful to add here. As you note the same people
are listed for for both drivers under ipw2x00 so we do not have the same
problem.

Reinette


