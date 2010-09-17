Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:16761 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754813Ab0IQANU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Sep 2010 20:13:20 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 16 Sep 2010 17:13:14 -0700
From: Vipin Mehta <Vipin.Mehta@Atheros.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "greg@kroah.com" <greg@kroah.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Date: Thu, 16 Sep 2010 17:13:17 -0700
Subject: RE: [PATCH] staging: ath6kl: Including a header file to fix a
 compilation error
Message-ID: <35B17FE5076C7040809188FBE7913F983F23937A92@SC1EXMB-MBCL.global.atheros.com>
References: <1284682087-19351-1-git-send-email-vmehta@atheros.com>
 <AANLkTinPPuie4cUjdLcDD=tt_pfYVx9n+r3xvJKB2=tx@mail.gmail.com>
In-Reply-To: <AANLkTinPPuie4cUjdLcDD=tt_pfYVx9n+r3xvJKB2=tx@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

You meant 70 characters. Right ?

> -----Original Message-----
> From: Luis R. Rodriguez [mailto:mcgrof@gmail.com]
> Sent: Thursday, September 16, 2010 5:11 PM
> To: Vipin Mehta
> Cc: greg@kroah.com; linux-wireless@vger.kernel.org;
> devel@driverdev.osuosl.org
> Subject: Re: [PATCH] staging: ath6kl: Including a header file to fix a
> compilation error
> 
> On Thu, Sep 16, 2010 at 5:08 PM, Vipin Mehta <vmehta@atheros.com> wrote:
> > The commit fixes a compilation error that was encountered while using a
> specific kernel configuration file. The problem was the use of some
> fuunctions defined in <linux/semaphore.h> without including the header
> file explicitly. It was probably working before because of the dependency
> getting implicitly satisfied via some other header file. Also, eliminating
> the inclusion of the same header file more than once. The code needs
> additional cleanup and may be addressed by a subsequent commit.
> 
> Keep the commit log lines to less than about 70 lines or so.
> 
>  Luis
