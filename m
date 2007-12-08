Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49003
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753650AbXLHBgE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 20:36:04 -0500
Date: Fri, 07 Dec 2007 17:36:03 -0800 (PST)
Message-Id: <20071207.173603.37779169.davem@davemloft.net> (sfid-20071208_013607_771404_B7C850BA)
To: dsd@gentoo.org
Cc: mb@bu3sch.de, jt@hpl.hp.com, shaddy_baddah@hotmail.com,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: zd1211rw (2.6.22 sparc64): unaligned access (do_rx)
From: David Miller <davem@davemloft.net>
In-Reply-To: <47595D4E.6080901@gentoo.org>
References: <20071207.043407.72593148.davem@davemloft.net>
	<200712071436.08954.mb@bu3sch.de>
	<47595D4E.6080901@gentoo.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Daniel Drake <dsd@gentoo.org>
Date: Fri, 07 Dec 2007 14:48:46 +0000

> Please correct me if I'm wrong, but adding the "packed" attribute causes 
> gcc to generate extra instructions to avoid the potentially unaligned 
> accesses.
> (i.e. it basically does put_aligned/get_unaligned automatically)

Exactly.
