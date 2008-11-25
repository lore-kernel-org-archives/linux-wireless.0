Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13403 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400AbYKYCbm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 21:31:42 -0500
Subject: Re: wireless-regdb: flaw in general functionality
From: Pavel Roskin <proski@gnu.org>
To: Richard Farina <sidhayn@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <492B623E.5030202@gmail.com>
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla>
	 <1227568883.28878.15.camel@dv>
	 <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com>
	 <492B623E.5030202@gmail.com>
Content-Type: text/plain
Date: Mon, 24 Nov 2008 21:31:39 -0500
Message-Id: <1227580299.32415.2.camel@dv> (sfid-20081125_033203_938323_EB77B0C2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-11-24 at 21:26 -0500, Richard Farina wrote:

> I'm all for adding it to crda as no-transmit but, is that a valid flag?  
> Also, how well does it work?  From a monitor mode interface you can 
> inject raw packets out of the interface.  Would just adding 
> "no-transmit" into the crda line work?  I certainly don't see this in 
> the crda code anywhere, nor in the definition of regdb file.  I presume 
> this has to be added?

I don't know anything about the process for introducing new CRDA flags.
If it's hard to do, maybe the transmit power could be set to 0?

-- 
Regards,
Pavel Roskin
