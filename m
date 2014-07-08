Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0041.hostedemail.com ([216.40.44.41]:51036 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752106AbaGHQgD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jul 2014 12:36:03 -0400
Message-ID: <1404837357.932.20.camel@joe-AO725> (sfid-20140708_183626_026747_62F5D9B8)
Subject: Re: [PATCH v2 04/10] lib/vsprintf: add %*pE[achnops] format
 specifier
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 08 Jul 2014 09:35:57 -0700
In-Reply-To: <1404807878.5102.85.camel@smile.fi.intel.com>
References: <1404746512-12749-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404746512-12749-5-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1404751810.27043.90.camel@joe-AO725>
	 <1404807878.5102.85.camel@smile.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-07-08 at 11:24 +0300, Andy Shevchenko wrote:
> On Mon, 2014-07-07 at 09:50 -0700, Joe Perches wrote:
> > Perhaps better if -1 was accepted by string_escape_mem
> > as a strlen request or just ignored as a 0 length is
> > above.
> 
> Would it be any benefit here?

Dunno, it was just a thought for you.

> > fyi: hex_string emits nothing on printk("%ph", buf);
> 
> Works just fine. How did you check it?

By not reading the code correctly.
So what you have is fine.


