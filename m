Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41878 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab1KRU63 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 15:58:29 -0500
Date: Fri, 18 Nov 2011 15:53:28 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Subject: Re: [PATCH 2/2] compat: implement dummy security_sk_clone
Message-ID: <20111118205327.GB2663@tuxdriver.com> (sfid-20111118_215832_700977_D26D4DFC)
References: <1321490374-24529-1-git-send-email-linville@tuxdriver.com>
 <1321490374-24529-2-git-send-email-linville@tuxdriver.com>
 <4EC6B3FA.90502@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4EC6B3FA.90502@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 18, 2011 at 08:37:30PM +0100, Hauke Mehrtens wrote:
> On 11/17/2011 01:39 AM, John W. Linville wrote:
> > This has been defined in include/linux/security.h for some time, but was
> > only given an EXPORT_SYMBOL for 3.2.  Add a compat_* definition to avoid
> > breaking the module load with an undefined symbol.
> > 
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>

<snip>

> Hi,
> 
> security_sk_clone gets also exported in Linux-3.1 so this should move to
> include/linux/compat-3.1.h. 3.1-rcX did not contain this fix, but I hope
> nobody is using this any more.
> 
> Hauke
> 
> $ git tag --contains 6230c9b4f8957c8938ee4cf2d03166d3c2dc89de
> v3.1
> v3.1.1
> v3.2-rc1
> v3.2-rc2

My bad -- must have misread it!  Sending a new one now...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
