Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42003 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753124Ab2AKVQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jan 2012 16:16:03 -0500
Date: Wed, 11 Jan 2012 16:07:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: add default option to avoid duplicating device
 support with brcmsmac
Message-ID: <20120111210736.GE11093@tuxdriver.com> (sfid-20120111_221609_301642_9F4F6058)
References: <1326315180-29398-1-git-send-email-linville@tuxdriver.com>
 <4F0DF91F.6020005@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F0DF91F.6020005@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 11, 2012 at 10:03:27PM +0100, Arend van Spriel wrote:
> On 01/11/2012 09:53 PM, John W. Linville wrote:
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > ---
> >  drivers/net/wireless/b43/Kconfig |    5 +++++
> >  drivers/net/wireless/b43/main.c  |    2 ++
> >  2 files changed, 7 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/b43/Kconfig b/drivers/net/wireless/b43/Kconfig
> > +config B43_BCMA_EXTRA
> > +	bool "Support for devices also supported by brcmsmac"
> > +	depends on B43_BCMA
> > +	default n
> 
> If I am not mistaken the 'default n' is not really needed.

But I _really_ mean it!! :-)

I'll drop that line in the final commit...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
