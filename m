Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21498 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755369AbYHARJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 13:09:24 -0400
Subject: Re: Vendor support stickers for devices supported under Linux
	wireless
From: Pavel Roskin <proski@gnu.org>
To: Michael Renzmann <mrenzmann@madwifi.org>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <3659.194.45.26.221.1217581093.squirrel@webmail.madwifi.org>
References: <43e72e890807301327j54be2453r836964c708d75458@mail.gmail.com>
	 <40f31dec0807310657l36b052bfu510415d50c14718d@mail.gmail.com>
	 <3659.194.45.26.221.1217581093.squirrel@webmail.madwifi.org>
Content-Type: text/plain
Date: Fri, 01 Aug 2008 13:09:21 -0400
Message-Id: <1217610561.13107.28.camel@dv> (sfid-20080801_190937_139924_312EEFA6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-08-01 at 10:58 +0200, Michael Renzmann wrote:

> How about a "Linux Wireless Foundation"? Some kind of official entity that
> wireless vendors could talk to for Linux support, certification process
> for getting the logo, and so on.

My concern is that giving any certification would imply that we promise
to keep the driver in the Linux sources.  However, I don't think we can
accept legal obligations on behalf of the developers.

Linus can remove any driver at any time.  We can hope that he will act
rationally, but even then, the driver may be found to have fundamental
problems after the certification.  If Linus removes a driver for a
certified device, will "Linux Wireless Foundation" fork the kernel?

-- 
Regards,
Pavel Roskin
