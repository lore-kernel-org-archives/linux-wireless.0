Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.aramid.it ([213.21.189.122]:1696 "EHLO aramid.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbZHERvp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 13:51:45 -0400
Date: Wed, 5 Aug 2009 19:31:32 +0200
From: Andrea Rossato <mailing_list@istitutocolli.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: "ath5k-devel@venema.h4ckr.net" <ath5k-devel@venema.h4ckr.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [ath5k-devel] a possible regression in managed mode ?
Message-ID: <20090805173129.GD18549@eeepc.nowhere.net>
References: <43e72e890908050810h29c28945o4732f8606caab9fb@mail.gmail.com> <20090805155330.GC4727@mosca> <20090805165227.GA18394@eeepc.nowhere.net> <20090805171523.GE4727@mosca>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20090805171523.GE4727@mosca>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 05, 2009 at 10:15:23AM -0700, Luis R. Rodriguez wrote:
> > When I use 2.6.29.4 everything works smoothly and association and
> > authentication always happen at the first try. The "authentication
> > timeout" issue only happens with the wireless-testing kernel from git.
> 
> This is when using wpa_supplicant 0.6.9? Or when using both 0.6.9
> and git version of the supplicant?

That happens with both versions.

> You know you can just have wpa_supplicant try to reassoc for you
> upon disconnection automatically, right? I use something like this:

yes, but in my setup I need to force a reassociation in order to run
the dhclient and the correct configuration script - but not at boot
time.

Thanks

Andrea
