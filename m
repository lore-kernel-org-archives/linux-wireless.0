Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:57409 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbcABJJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jan 2016 04:09:24 -0500
Subject: Re: net-libertas: Better exception handling in
 if_spi_host_to_card_worker()
To: Julia Lawall <julia.lawall@lip6.fr>
References: <566ABCD9.1060404@users.sourceforge.net>
 <5686F0B2.5000000@users.sourceforge.net>
 <56870866.7020000@cogentembedded.com>
 <568785B3.5000905@users.sourceforge.net>
 <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
	libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <5687939E.7010701@users.sourceforge.net> (sfid-20160102_101043_963543_D70A551F)
Date: Sat, 2 Jan 2016 10:08:46 +0100
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1601020914100.2063@localhost6.localdomain6>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I assume that a software development taste can evolve, can't it?
> 
> So far, you have gotten several down votes for this kind of change,

I am curious when more contributors will share corresponding opinions.


> and no enthusiasm.

How many software designers and developers can become enthusiastic
about better exception handling to some degree?


> The code that is performance critical, you should probably not touch, ever.

I imagine that technical evolution will result in further considerations
so that "unchangeable" components can be adjusted once more.


> The people who wrote it knew what was important and what was not.

I might come along at some places where the affected knowledge will also evolve.

Regards,
Markus
