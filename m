Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18879 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbYKFQpR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 11:45:17 -0500
Subject: Re: problems with ath5k driver.
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: msan <msan@email.it>, linux-wireless@vger.kernel.org
In-Reply-To: <43e72e890811051322m43efbf03gd21770be382e807d@mail.gmail.com>
References: <geiib4$apo$2@ger.gmane.org>
	 <20081103191625.4rwqio60gsgs0gso-cebfxv@webmail.spamcop.net>
	 <get27e$ka2$1@ger.gmane.org>
	 <43e72e890811051322m43efbf03gd21770be382e807d@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 06 Nov 2008 11:40:58 -0500
Message-Id: <1225989658.4276.4.camel@dv> (sfid-20081106_174523_017914_35DFBFB9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-05 at 13:22 -0800, Luis R. Rodriguez wrote:

> > "ath5k phy0: Support for RF2425 is under development."
> >
> > So it doesn't work even with linux 2.6.27.
> 
> Now that you are on 2.6.27 try compat-wireless:
> 
> http://wireless.kernel.org/en/users/Download
> 
> This gets you bleeding edge. Or you can also just try wireless-testing directly.

Actually, I tested AR5007EG with Linux 2.6.27 and it worked, even with
WPA.  So the problem is probably elsewhere (bad antenna, lack of APs
around, curly hands, irrational fear of things "under development" etc).

-- 
Regards,
Pavel Roskin
