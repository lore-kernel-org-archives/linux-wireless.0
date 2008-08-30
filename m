Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34499
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753389AbYH3TXx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2008 15:23:53 -0400
Date: Sat, 30 Aug 2008 12:23:48 -0700 (PDT)
Message-Id: <20080830.122348.103905579.davem@davemloft.net> (sfid-20080830_212401_014898_46DE1CDD)
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2008-08-29
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080830125833.GC11718@tuxdriver.com>
References: <20080829205414.GB11718@tuxdriver.com>
	<20080829.140303.71048853.davem@davemloft.net>
	<20080830125833.GC11718@tuxdriver.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "John W. Linville" <linville@tuxdriver.com>
Date: Sat, 30 Aug 2008 08:58:33 -0400

> Ah, yes...it looks trivial to fix, but the trivial fix won't build!
> 
> I have it fixed here:
> 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-next-2.6.git merged-test
> 
> And the fixed file is the same as what is in wireless-testing.

John, I already merged net-2.6 into net-next-2.6 last night, so you
can give a check to see if I mucked it up or not :-)
