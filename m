Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:20567 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753291Ab2JEKUU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 06:20:20 -0400
Message-ID: <1349432398.10584.31.camel@smile> (sfid-20121005_122023_290051_523A7CBB)
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	bzhao@marvell.com
Date: Fri, 05 Oct 2012 13:19:58 +0300
In-Reply-To: <20121005100719.GD12229@aemeltch-MOBL1>
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
	 <1349368379.2008.16.camel@joe-AO722> <1349419996.10584.5.camel@smile>
	 <1349420428.10584.8.camel@smile> <20121005100719.GD12229@aemeltch-MOBL1>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-10-05 at 13:07 +0300, Andrei Emeltchenko wrote: 
> On Fri, Oct 05, 2012 at 10:00:28AM +0300, Andy Shevchenko wrote:

> > And one finding more: buffers are defined as u16. I'm afraid the both
> > previous and proposed versions are printing something interesting, like
> > only half of the defined data.
> 
> The patch only changes printing format. The other logical change would
> come better in other patch, maybe Bing could comment here.
What about to fix logic first and then to substitute the
print_hex_dump_bytes() calls?

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
