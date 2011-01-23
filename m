Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:54585 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab1AWJdW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jan 2011 04:33:22 -0500
Date: Sun, 23 Jan 2011 01:32:32 -0800
From: Greg KH <greg@kroah.com>
To: Joe Perches <joe@perches.com>
Cc: Vipin Mehta <vmehta@atheros.com>,
	Vipin Mehta <Vipin.Mehta@Atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 00/83] staging: ath6kl: Style cleanup
Message-ID: <20110123093232.GA29967@kroah.com>
References: <1295637798-18355-1-git-send-email-vmehta@atheros.com>
 <20110121193830.GA17789@kroah.com>
 <20110121194840.GA18603@vmehta-desktop>
 <20110121195509.GB18700@kroah.com>
 <20110121200907.GA18651@vmehta-desktop>
 <20110121211625.GA15966@kroah.com>
 <1295742255.21754.3.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1295742255.21754.3.camel@Joe-Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 22, 2011 at 04:24:15PM -0800, Joe Perches wrote:
> On Fri, 2011-01-21 at 13:16 -0800, Greg KH wrote:
> > I need this series against the proper branch, if I am going to be able
> > to apply them.
> 
> I am working on this major style rewrite of ath6kl right now.
> 
> Please do not apply new patches to ath6kl this upcoming week
> as it takes quite a bit of work to resync and validate 100+
> patches.

Sorry, but that's not how you do things.  Nor is it how I do things, if
people send me patches, I take them in the order in which they arrive.

NEVER send 100+ patches, send out what you have, when you have them,
which makes stuff like this, much easier to handle.

And wasn't this driver just a "placeholder" while a "real" driver was
being written?

good luck,

greg k-h
