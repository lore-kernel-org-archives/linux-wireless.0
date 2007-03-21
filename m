Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2408 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933602AbXCUAoz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 20:44:55 -0400
Date: Tue, 20 Mar 2007 20:22:22 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <IvDoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: EEPROM_93CX6 placement (was Re: 2.6.21-rc4-mm1)
Message-ID: <20070321002222.GA4110@tuxdriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Comments?  Patches?

----- Forwarded message from Randy Dunlap <randy.dunlap@oracle.com> -----

> Date: 	Tue, 20 Mar 2007 16:49:23 -0700
> From: Randy Dunlap <randy.dunlap@oracle.com>
> To: Andrew Morton <akpm@linux-foundation.org>
> Cc: linux-kernel@vger.kernel.org
> Subject: Re: 2.6.21-rc4-mm1
> In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
> Organization: Oracle Linux Eng.
> X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
> X-Whitelist: TRUE
> X-Whitelist: TRUE
> X-Brightmail-Tracker: AAAAAQAAAAI=
> Precedence: bulk
> X-Mailing-List: 	linux-kernel@vger.kernel.org
> X-Spam-Status: No, score=-2.6 required=3.0 tests=AWL,BAYES_00,SPF_HELO_PASS,
> 	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham version=3.1.3-gr0
> X-Spam-Checker-Version: SpamAssassin 3.1.3-gr0 (2006-06-01) on 
> 	ra.tuxdriver.com
> 
> On Mon, 19 Mar 2007 20:56:23 -0800 Andrew Morton wrote:
> 
> > 
> > Temporarily at
> > 
> >   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/
> > 
> > Will appear later at
> > 
> >   ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc4/2.6.21-rc4-mm1/
> 
> 
> I think that this:
> 
> config EEPROM_93CX6
> 	tristate "EEPROM 93CX6 support"
> 	---help---
> 	This is a driver for the EEPROM chipsets 93c46 and 93c66.
> 	The driver supports both read as well as write commands.
> 
> should not be in lib/Kconfig.  lib/ is not for drivers.
> or (simpler) s/driver/library/
> but I think I'd rather see it in drivers/misc/.
> 
> 
> and the help text needs to be indented 2 more spaces...
> 
> ---
> ~Randy
> boilerplate:
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

----- End forwarded message -----

-- 
John W. Linville
linville@tuxdriver.com
