Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from adelie.ubuntu.com ([82.211.81.139]:52037 "EHLO
	adelie.ubuntu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE2Nb3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2007 09:31:29 -0400
Subject: Re: [2/3] 2.6.22-rc3: known regressions with patches
From: Ben Collins <ben.collins@ubuntu.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
	Ben Collins <bcollins@ubuntu.com>, yoshfuji@linux-ipv6.org,
	Maximilian Engelhardt <maxi@daemonizer.de>,
	linux-wireless@vger.kernel.org, developers@islsm.org,
	=?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	linux-ide@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
	Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>,
	Francis Russell <francisrussell@btopenworld.com>,
	Alan Cox <alan@redhat.com>, sparclinux@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	"Horst H. von Brand" <vonbrand@inf.utfsm.cl>
In-Reply-To: <465C2253.4070307@googlemail.com>
References: <465C203A.1020200@googlemail.com>
	 <465C2253.4070307@googlemail.com>
Content-Type: text/plain
Date: Tue, 29 May 2007 09:05:59 -0400
Message-Id: <1180443959.6666.192.camel@cunning>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-05-29 at 14:53 +0200, Michal Piotrowski wrote:

> Subject    : OOPS triggered by ip(8) deconfiguring a network interface
> References : http://bugzilla.kernel.org/show_bug.cgi?id=8491
> Submitter  : Ben Collins <bcollins@ubuntu.com>
> Patch      : http://marc.info/?l=linux-netdev&m=117915849224816&w=2
>              commit 5632c5152aa621885d87ea0b8fdd5a6bb9f69c6f
> Status     : bug probably fixed

Seems to be fixed, and just marked it resolved on bugzilla.

-- 
Ubuntu   : http://www.ubuntu.com/
Linux1394: http://wiki.linux1394.org/

