Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:5575 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762318AbXFEWOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2007 18:14:48 -0400
Message-ID: <4665C393.2000507@linux.intel.com>
Date: Tue, 05 Jun 2007 13:12:03 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: warnings in git-wireless
References: <20070605020614.3f06b2ab.akpm@linux-foundation.org> <20070605115701.GA5391@tuxdriver.com>
In-Reply-To: <20070605115701.GA5391@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Tue, Jun 05, 2007 at 02:06:14AM -0700, Andrew Morton wrote:
> 
>> Please, don't anybody dare think about thinking about letting this anywhere
>> near mainline until it has had a thorough review.  Or at least, a little bit
>> of review.
> 
> Don't worry -- I assure you that everyone is aware of the issues.
> 
> John

Yes, we certainly don't want a driver to be "near mainline" that does things that the rest of the kernel and other drivers are doing.  We should force them to stay out-of-tree until any and everything is resolved.  Heaven forbid that the code should be merged, contributed, and improved upon as a community.

You'd think these guys were trying to enable folks with a driver so they can use the hardware they bought or something.  Its almost laughable.  What idiots.

James
