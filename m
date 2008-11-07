Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:64947 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752324AbYKGAsd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 19:48:33 -0500
Message-ID: <4913905F.4080203@lwfinger.net> (sfid-20081107_014838_037176_10DCBA7A)
Date: Thu, 06 Nov 2008 16:48:31 -0800
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Wilson Ribeiro <wribjr@gmail.com>
CC: John Linville <linville@tuxdriver.com>,
	=?ISO-8859-1?Q?Stefanik_G=E1?= =?ISO-8859-1?Q?bor?=
	<netrolller.3d@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Re: Realtek wireless 8187se
References: <740646d0811040501w5571d464u757e05399803f768@mail.gmail.com>	 <69e28c910811040852u7f3f3481t7bf31ad3af8c03ad@mail.gmail.com>	 <49108E26.4040205@lwfinger.net> <740646d0811041021qd4ab88bs434ddb8d1ad65a80@mail.gmail.com>
In-Reply-To: <740646d0811041021qd4ab88bs434ddb8d1ad65a80@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found someone that has hacked the 8185 driver to work with the 8187se. If you
are willing to test, I will look at the differences between his driver and the
Realtek version that he started with.

If you want to participate, you will need the 2.6.27 kernel of the
wireless-testing git tree (better) and the tools to build your own kernel. That
will include (at least) make and gcc. For the wireless-testing kernel, you will
also need git.

Larry
