Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from agminet01.oracle.com ([141.146.126.228]:47125 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbXERVD3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 May 2007 17:03:29 -0400
Date: Fri, 18 May 2007 14:06:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: James Ketrenos <jketreno@linux.intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH]  Add iwlwifi wireless drivers
Message-Id: <20070518140619.a7e30a56.randy.dunlap@oracle.com>
In-Reply-To: <464DF7FC.5070702@linux.intel.com>
References: <464B7B7C.5080800@linux.intel.com>
	<20070516182700.912a21ed.randy.dunlap@oracle.com>
	<464DF7FC.5070702@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 May 2007 12:01:16 -0700 James Ketrenos wrote:

> Randy Dunlap wrote:
> >> 	http://intellinuxwireless.org/iwlwifi/0001-Add-iwlwifi-wireless-drivers.patch
> > Some comments/review, mostly not-code-related:
> > 
> 
> Here is the current status (everything not described below has been fixed in GIT, and is available in the patch at http://intellinuxwireless.org/iwlwifi/0001-v2-Add-iwlwifi-wireless-drivers.patch:
> 

[specific updates clipped]

> Are you OK with iwlwifi addressing the above post-merge into wireless-dev?

/me points to Mr. Linville.  :)

There are still some review items that need quick attention IMO,
like the 32/64-bit dma_addr_t issue.

However, I'm in favor of merging into wireless-dev if that's what will
speed up general intel wireless merging and maintainence on a more
timely basis instead of seeing giant patches every few months.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
