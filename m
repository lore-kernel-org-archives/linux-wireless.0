Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60027 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab1EPUe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2011 16:34:57 -0400
Date: Mon, 16 May 2011 13:33:33 -0700
From: Greg KH <greg@kroah.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: Clemens Noss <cnoss@gmx.de>, "gregkh@suse.de" <gregkh@suse.de>,
	"devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] staging: brcm80211: fix cast to pointer from integer
Message-ID: <20110516203333.GB17698@kroah.com> (sfid-20110516_223509_495827_8FB770EF)
References: <1305492330-19575-1-git-send-email-cnoss@gmx.de>
 <4DD105FE.9040500@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4DD105FE.9040500@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 16, 2011 at 01:09:50PM +0200, Roland Vossen wrote:
> Greg, please also merge this to the staging-linus branch since it
> might resolve an instability issue.

It "might"?

Is this a regression?  Do people see the problem on the .38 kernel as
well?

It's way too late for anything but severe regressions to be sent to
Linus at this point in time...

thanks,

greg k-h
