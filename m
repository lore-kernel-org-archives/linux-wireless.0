Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:51686 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXERU55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 16:57:57 -0400
Message-ID: <464E134D.60000@garzik.org>
Date: Fri, 18 May 2007 16:57:49 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <20070516182700.912a21ed.randy.dunlap@oracle.com> <464DF7FC.5070702@linux.intel.com>
In-Reply-To: <464DF7FC.5070702@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

James Ketrenos wrote:
> Randy Dunlap wrote:
>> 15.  Limit source lines to <= 80 columns (this patch contains
>> over 200 lines that are > 80 columns).
> 
> Fixed in the .c files.  Still have 155 instances in the .h files (most 
> due to mid-line tabs)


See my email on this subject.  This is NOT a hard and fast rule.  If you 
have to do something stupid to the formatting to get it to fit, then you 
are moving in the wrong direction.

As an aside, sometimes long lines are an indication that a function 
needs to be broken up into smaller sub-functions.

	Jeff


