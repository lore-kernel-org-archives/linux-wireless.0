Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:55251 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368AbbBYMXg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Feb 2015 07:23:36 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1YQb02-0002aK-Pt
	for linux-wireless@vger.kernel.org; Wed, 25 Feb 2015 13:23:34 +0100
Received: from 114.124.24.192 ([114.124.24.192])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 13:23:34 +0100
Received: from jockyw2001 by 114.124.24.192 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Wed, 25 Feb 2015 13:23:34 +0100
To: linux-wireless@vger.kernel.org
From: Jocky Wilson <jockyw2001@gmail.com>
Subject: Re: brcmfmac43241b4-sdio / Thinkpad Tablet 10 issues
Date: Wed, 25 Feb 2015 12:23:28 +0000 (UTC)
Message-ID: <loom.20150225T131550-21@post.gmane.org> (sfid-20150225_132341_689770_3F52CF92)
References: <54E2E1CD.5020203@m-labs.hk> <54E31CD5.70901@broadcom.com> <54E778F9.1000500@m-labs.hk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sebastien Bourdeauducq <sb@...> writes:

> 
> On Tuesday, February 17, 2015 03:49 AM, Arend van Spriel wrote:
> > So it is a one-off and not showing the issue you are seeing. Your issue
> > seems to be due to failing firmware so you may need b5 firmware.
> 
> Making some progress :)
> ...
> I guess that the driver has bugs with decoding some of the data sent by 
> the card.
> 
I can confirm this with my Thinkpad Tablet 8 
which has same chip revision. 
Arend: do you need anything else to be tested?

/JockyW


