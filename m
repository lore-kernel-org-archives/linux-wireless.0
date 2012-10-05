Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:6770 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755228Ab2JEM5p (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 08:57:45 -0400
Date: Fri, 5 Oct 2012 15:58:52 +0300
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Joe Perches <joe@perches.com>, linux-wireless@vger.kernel.org,
	bzhao@marvell.com
Subject: Re: [PATCH] mwifiex: Using %*phD instead of print_hex_dump_bytes
Message-ID: <20121005125849.GI12229@aemeltch-MOBL1> (sfid-20121005_145748_812746_0428E094)
References: <1349342161-27008-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
 <1349368379.2008.16.camel@joe-AO722>
 <1349419996.10584.5.camel@smile>
 <1349420428.10584.8.camel@smile>
 <20121005100719.GD12229@aemeltch-MOBL1>
 <1349432398.10584.31.camel@smile>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1349432398.10584.31.camel@smile>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 05, 2012 at 01:19:58PM +0300, Andy Shevchenko wrote:
> On Fri, 2012-10-05 at 13:07 +0300, Andrei Emeltchenko wrote: 
> > On Fri, Oct 05, 2012 at 10:00:28AM +0300, Andy Shevchenko wrote:
> 
> > > And one finding more: buffers are defined as u16. I'm afraid the both

Looking at the output:

mwifiex_sdio mmc0:0001:1: last_cmd_id: 28 00 28 00 28

I suspect that they meant u8.

Best regards 
Andrei Emeltchenko 

