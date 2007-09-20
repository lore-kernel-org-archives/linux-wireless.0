Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:32828 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755012AbXITQh4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 12:37:56 -0400
Message-ID: <46F2A1D4.9030601@lwfinger.net>
Date: Thu, 20 Sep 2007 11:37:40 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Daniel Drake <dsd@gentoo.org>
CC: "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
	jeff@garzik.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, kune@deine-taler.de
Subject: Re: Please pull 'z1211' branch of wireless-2.6
References: <20070919181005.GB5483@tuxdriver.com> <46F19DD0.2050605@gentoo.org> <20070920134730.GC6748@tuxdriver.com> <46F28374.9040106@gentoo.org>
In-Reply-To: <46F28374.9040106@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake wrote:
> John W. Linville wrote:

>> If you are determined not to have it in 2.6.24 then I will relent.
>> I will also suggest that Larry start sending any softmac bugs to
>> you... :-)
> 
> That's fine.

You're on. BTW, I will let you be the primary tester of "[PATCH] fix softmac lockdep reports" that
Johannes posted earlier today. I see you were CC'd. I plan on testing it with bcm43xx, but I won't
get to it for a couple of days.

Larry

