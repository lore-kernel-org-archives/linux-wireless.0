Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:45502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751240Ab0LOVOt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 16:14:49 -0500
Date: Wed, 15 Dec 2010 13:14:33 -0800
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Joe Perches <joe@perches.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request:  staging: ath6kl: linux kernel style cleanups
Message-ID: <20101215211433.GA932@kroah.com>
References: <AANLkTimfPFeLy5sfDDS5fXiK8X8UT2x8dhzZ+_FEjrTo@mail.gmail.com>
 <1292363199.26726.34.camel@Joe-Laptop>
 <AANLkTikD440S8AWcOdib7BfTR5a7CaTuYjkysi43oaQZ@mail.gmail.com>
 <35B17FE5076C7040809188FBE7913F98406D8912FE@SC1EXMB-MBCL.global.atheros.com>
 <1292402343.26726.155.camel@Joe-Laptop>
 <35B17FE5076C7040809188FBE7913F98406D966A13@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35B17FE5076C7040809188FBE7913F98406D966A13@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 12:47:42PM -0800, Vipin Mehta wrote:
> 
> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com] 
> Sent: Wednesday, December 15, 2010 12:39 AM
> To: Vipin Mehta
> Cc: Luis R. Rodriguez; devel@driverdev.osuosl.org; linux-wireless
> Subject: pull request: staging: ath6kl: linux kernel style cleanups
> 
> A too-large-to-post (~2MB) changeset to ath6kl, sent separately to Vipin and Luis.
> 
> Mostly done mechanically.  Compile tested only.
> 
> The following changes since commit e3d7018ee7b5205a80b1011f5a86432de40ce74a:
> 
>   Add linux-next specific files for 20101215 (2010-12-15 14:37:00 +1100)
> 
> are available in the git repository at:
>   git://repo.or.cz/linux-2.6/trivial-mods.git 20101215-ath6kl
> 
> LGTM.
> 
> Greg,
> Can you kindly pull in these changes into ath6kl?

Please send them to me in patch form so that I can apply them.  You need
to provide your ack on them as well.

> Also, would you know
> what kind of changes can be migrated to Linus's 2.6.37 kernel. Is it
> only limited to bug fixes or code cleanup can also be a part of it?

At this point in the release cycle, what do you think?

If you are unsure of how the release cycle works, please read
Documentation/development_process/

thanks,

greg k-h
