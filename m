Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37130
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab1D2Dbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Apr 2011 23:31:33 -0400
Date: Thu, 28 Apr 2011 20:31:00 -0700 (PDT)
Message-Id: <20110428.203100.193725173.davem@davemloft.net> (sfid-20110429_053138_672898_37F09573)
To: padovan@profusion.mobi
Cc: Larry.Finger@lwfinger.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: pull request: wireless-next-2.6 2011-04-25
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110429031143.GA2353@joana>
References: <20110425.130435.112597353.davem@davemloft.net>
	<4DB5DFBC.3070203@lwfinger.net>
	<20110429031143.GA2353@joana>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Gustavo F. Padovan" <padovan@profusion.mobi>
Date: Fri, 29 Apr 2011 00:11:43 -0300

> * Larry Finger <Larry.Finger@lwfinger.net> [2011-04-25 15:55:24 -0500]:
> 
>> Unfortunately, the 64-bit variant of gcc v4.5.1 will miss some of these. I find 
>> I need to compile code on a 32-bit system and using an older compiler to catch 
>> all. Perhaps that explains the error that crept through here.
> 
> That could be a reason, I have gcc 4.5.2 (64-bit). I've built this code many times
> before send pull request and never saw that warning, and it's clearly a bug,
> indeed. 

I would buy this line of reasoning.

Except that I do all of my test builds with 64-bit gcc's, on sparc64
and x86-64.
