Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33188 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281Ab0IRCGp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 22:06:45 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 17 Sep 2010 19:06:39 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: Greg KH <greg@kroah.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Fri, 17 Sep 2010 19:06:42 -0700
Subject: RE: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <35B17FE5076C7040809188FBE7913F983F23A2763A@SC1EXMB-MBCL.global.atheros.com>
References: <1284742495-2970-1-git-send-email-vmehta@atheros.com>
 <4C93A412.2070005@oracle.com> <20100917180056.GA20199@kroah.com>
 <35B17FE5076C7040809188FBE7913F983F23A275AF@SC1EXMB-MBCL.global.atheros.com>
 <20100917234627.GA26329@kroah.com>
In-Reply-To: <20100917234627.GA26329@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> {sigh}  Line length please...
Sorry about that. I have now configured outlook to wrap the line at 70 characters. It was 76 by default. Hopefully, it shows up better now.

> But that has nothing to do with this fix, right?  Don't mix things
> in a
> single patch.  Cleanup is good and nice, but don't do that in a "fix
> a
> problem" patch at the same time.
> 
> Remember:
> 	One patch per "thing" you do.
I have split the patch into two and sent you the patches.
