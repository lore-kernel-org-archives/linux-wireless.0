Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet10.oracle.com ([148.87.113.121]:25112 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab1ELXTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 19:19:48 -0400
Date: Thu, 12 May 2011 16:19:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Michael Buesch <mb@bu3sch.de>
Subject: Re: linux-next: Tree for May 12 (ssb)
Message-Id: <20110512161914.e16be4d3.randy.dunlap@oracle.com> (sfid-20110513_012005_691238_28AB0485)
In-Reply-To: <20110512142303.8117a0b6.sfr@canb.auug.org.au>
References: <20110512142303.8117a0b6.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 12 May 2011 14:23:03 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20110511:


on i386 and x86_64 (many randconfigs fail with these errors):

drivers/ssb/main.c:1336: error: 'SSB_PCICORE_BCAST_ADDR' undeclared (first use in this function)
drivers/ssb/main.c:1337: error: 'SSB_PCICORE_BCAST_DATA' undeclared (first use in this function)
drivers/ssb/main.c:1349: error: 'struct ssb_pcicore' has no member named 'dev'

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
