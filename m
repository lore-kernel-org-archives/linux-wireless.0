Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:34472 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754078AbXERWFv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 18:05:51 -0400
Message-ID: <464E1283.80509@linux.intel.com>
Date: Fri, 18 May 2007 13:54:27 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com> <464DF7FC.5070702@linux.intel.com> <464E134D.60000@garzik.org>
In-Reply-To: <464E134D.60000@garzik.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jeff Garzik wrote:
> James Ketrenos wrote:
>> Randy Dunlap wrote:
>>> 15.  Limit source lines to <= 80 columns (this patch contains
>>> over 200 lines that are > 80 columns).
>>
>> Fixed in the .c files.  Still have 155 instances in the .h files (most 
>> due to mid-line tabs)
> 
> See my email on this subject.  This is NOT a hard and fast rule.  If you 
> have to do something stupid to the formatting to get it to fit, then you 
> are moving in the wrong direction.

The bulk of the problems in the .h files are caused by Lindent injecting tabs instead of spaces between the C language item and the comment describing it, blowing the comments over 80.

That said, some of the define names are horrendously long... over time we can get those cleaned up w/ some sed scripts.

> As an aside, sometimes long lines are an indication that a function 
> needs to be broken up into smaller sub-functions.

Nod.

James
