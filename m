Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:50465 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993AbbFYUue (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Jun 2015 16:50:34 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1Z8E6S-0001tF-HH
	for linux-wireless@vger.kernel.org; Thu, 25 Jun 2015 22:50:32 +0200
Received: from 92.206.66.102 ([92.206.66.102])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 22:50:32 +0200
Received: from pommnitz by 92.206.66.102 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2015 22:50:32 +0200
To: linux-wireless@vger.kernel.org
From: Joerg <pommnitz@yahoo.com>
Subject: Re: iw and non-ASCII SSIDs
Date: Thu, 25 Jun 2015 20:50:25 +0000 (UTC)
Message-ID: <loom.20150625T224327-49@post.gmane.org> (sfid-20150625_225037_608129_0D468D05)
References: <loom.20150625T181029-814@post.gmane.org>  (sfid-20150625_181310_521075_380CF492) <1435255854.2096.18.camel@sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@...> writes:

> 
> On Thu, 2015-06-25 at 16:12 +0000, Joerg wrote:
> > Hello all,
> > is there a way to submit a non-ASCII SSID with iw? One that contains 
> > 0 as in an octet with value zero?
> 
> No, that doesn't seem to be possible in the code.
> 
> But it's certainly possible in wp_supplicant config file, which you
> should probably be using anyway?
> 
> johannes

That's what I thought from looking at the code, too. 

And no, this is for an IBSS network that uses an IPsec overlay for security. 
It doesn't use wpa_supplicant and changing the code that way would be a major 
hassle. 

I would volunteer to change iw to accept a hex encoded binary blob as SSID. 
What commandline would be acceptable?

Regards
  Joerg  



