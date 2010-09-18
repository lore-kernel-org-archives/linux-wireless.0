Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:59175 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab0IRFfB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Sep 2010 01:35:01 -0400
Date: Fri, 17 Sep 2010 22:11:22 -0700
From: Greg KH <greg@kroah.com>
To: Vipin Mehta <Vipin.Mehta@Atheros.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
	compilation error
Message-ID: <20100918051122.GA18733@kroah.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com> <4C93A412.2070005@oracle.com> <20100917180056.GA20199@kroah.com> <35B17FE5076C7040809188FBE7913F983F23A275AF@SC1EXMB-MBCL.global.atheros.com> <20100917234627.GA26329@kroah.com> <35B17FE5076C7040809188FBE7913F983F23A2763A@SC1EXMB-MBCL.global.atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <35B17FE5076C7040809188FBE7913F983F23A2763A@SC1EXMB-MBCL.global.atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 17, 2010 at 07:06:42PM -0700, Vipin Mehta wrote:
> > 
> > {sigh}  Line length please...
> Sorry about that. I have now configured outlook to wrap the line at 70 characters. It was 76 by default. Hopefully, it shows up better now.

No, it's still wrong, you need to fix outlook to properly add line ends
for your lines.

Or better yet, don't use outlook.  Seriously.  There are lots of other
email clients out there that are way better, and free, and some even
will work with your exchange server.

good luck,

greg k-h
