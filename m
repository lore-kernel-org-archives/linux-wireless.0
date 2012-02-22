Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0.aculab.com ([213.249.233.131]:37813 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752905Ab2BVJfy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 04:35:54 -0500
Received: from mx0.aculab.com ([127.0.0.1])
 by localhost (mx0.aculab.com [127.0.0.1]) (amavisd-new, port 10024) with SMTP
 id 01479-08 for <linux-wireless@vger.kernel.org>;
 Wed, 22 Feb 2012 09:35:50 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: [PATCH] checkpatch: Add some --strict coding style checks
Date: Wed, 22 Feb 2012 09:35:14 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B6E77@saturn3.aculab.com> (sfid-20120222_103559_848738_672B22CE)
In-Reply-To: <804857E1F29AAC47BF68C404FC60A18429B3EE@ORSMSX102.amr.corp.intel.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Allan, Bruce W" <bruce.w.allan@intel.com>,
	"Joe Perches" <joe@perches.com>,
	"David Miller" <davem@davemloft.net>,
	"Andy Whitcroft" <apw@shadowen.org>,
	"Andrew Morton" <akpm@linux-foundation.org>
Cc: <andrei.emeltchenko.news@gmail.com>, <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 
> 	if (!(func_a(x) &&
> 		func_b(y)))
> 		baz();

Gah - that is horrid for the 'preferred style'.
A quick glance at the code puts both the func_b()
and baz() calls as inside the if.

	David


