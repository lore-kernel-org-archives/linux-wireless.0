Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:33184 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbZGWWj1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 18:39:27 -0400
Subject: Re: any controller working in AP mode ?
From: Pavel Roskin <proski@gnu.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: Ram kumar <ramkumar.research@gmail.com>,
	Javier Cardona <javier@cozybit.com>, andrey@cozybit.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1248366724.2661.9.camel@mj>
References: <6306c640907142221o27c257aaw12f73da8118376f@mail.gmail.com>
	 <1247843954.25608.62.camel@mj> <1248277682.8929.0.camel@mj>
	 <200907230846.17683.hs4233@mail.mn-solutions.de>
	 <1248366724.2661.9.camel@mj>
Content-Type: text/plain
Date: Thu, 23 Jul 2009 18:39:25 -0400
Message-Id: <1248388765.2661.154.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-23 at 12:32 -0400, Pavel Roskin wrote:

> In case it matters, its FCC ID is T58331GU2006M1.  Some sites say its
> chipset is "Marvell 88W8338 + 88W8010", see e.g.
> http://www.xpcgear.com/zew2502.html

I've cracked it open.  The big chips are Marvell 88W8338-BDK1 and
Marvell 88W8010-NNB.  Thus, the above site is correct.

libertas and libertastf support 88W8388, which must be newer than
88W8338.

-- 
Regards,
Pavel Roskin
