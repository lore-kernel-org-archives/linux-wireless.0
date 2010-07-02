Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53236 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753450Ab0GBRAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jul 2010 13:00:11 -0400
Date: Fri, 2 Jul 2010 12:48:00 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Question on 'iw reg get/set'
Message-ID: <20100702164759.GE2381@tuxdriver.com>
References: <4C2CFAEB.9070302@candelatech.com>
 <20100702141216.GB2381@tuxdriver.com>
 <4C2E170E.6040207@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C2E170E.6040207@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 02, 2010 at 09:42:54AM -0700, Ben Greear wrote:
> On 07/02/2010 07:12 AM, John W. Linville wrote:

> >The ath9k driver is setting its own regulatory restrictions based on
> >its EEPROM.  Setting the domain from userland can only further restrict
> >the regulatory settings.  The '98' value represents a synthesized
> >regulatory domain, based on the intersection of the available source
> >of regulatory information (which can include the EEPROM, the userland
> >setting, and a country IE from your AP).
> 
> Is there any way to get/set these raw settings (like, whatever it has in EEPROM)?
> 
> I expect we may ship some of these systems overseas, and would like the flexibility
> to set the country-code for testing purposes, if nothing else.

I'll leave it to the Atheros guys to address this.

> Is there any documentation as to what '98' really means, or do we just ignore that
> value and look at the info printed out after that?

'98' pretty much means "look at the info" :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
