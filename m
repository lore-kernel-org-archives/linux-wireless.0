Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:52307 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751647Ab1GVQER (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 12:04:17 -0400
Date: Fri, 22 Jul 2011 09:04:14 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Stephen Rothwell <sfr@canb.auug.org.au>, zajec5@gmail.com,
	linux-wireless@vger.kernel.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for July 22 (bcma)
Message-Id: <20110722090414.4e3d80a5.rdunlap@xenotime.net> (sfid-20110722_180434_125844_15ECEEC4)
In-Reply-To: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
References: <20110722164237.2b3f6cbdedafa9e1d3f70867@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 22 Jul 2011 16:42:37 +1000 Stephen Rothwell wrote:

> Hi all,

(similar to a report from July 16:)

linux-next-20110722/drivers/bcma/driver_pci.c:175: error: 'SSB_PCICORE_BFL_NOPCI' undeclared (first use in this function)

This build error happens whether CONFIG_PCI is enabled or disabled (unlike
what I stated on July 16).

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
