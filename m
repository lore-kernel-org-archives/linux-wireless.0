Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47725 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752216AbZLNDdj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Dec 2009 22:33:39 -0500
Date: Sun, 13 Dec 2009 22:29:20 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] wireless: support internal statically compiled
 regulatory database
Message-ID: <20091214032920.GB4743@tuxdriver.com>
References: <1260755116-3829-1-git-send-email-linville@tuxdriver.com>
 <1260755719.4041.1.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1260755719.4041.1.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2009 at 02:55:19AM +0100, Marcel Holtmann wrote:
> Hi John,
> 
> > +config CFG80211_INTERNAL_REGDB
> > +	bool "use statically compiled regulatory rules database"
> > +	default n
> > +	depends on CFG80211
> > +	---help---
> > +	  This option generates an internal data structure representing
> > +	  the wireless regulatory rules described in net/wireless/db.txt
> > +	  and includes code to query that database.  This is an alternative
> > +	  to using CRDA for defining regulatory rules for the kernel.
> > +
> > +	  For details see:
> > +
> > +	  http://wireless.kernel.org/en/developers/Regulatory
> > +
> > +	  Most distributions have a CRDA package.  So if unsure, say N.
> 
> since it is pretty clear that people should be defaulting to CRDA, why
> not make it depend on CONFIG_EMBEDDED.

Other than expanding the amount of config options available, what are
the ramifications of selecting CONFIG_EMBEDDED?  Is it just a way of
hiding options that "normal" people don't need to see?  Or does it
have some significant change on the built kernel by itself?

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
