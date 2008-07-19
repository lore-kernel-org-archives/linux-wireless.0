Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53662 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750733AbYGSEPC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Jul 2008 00:15:02 -0400
Message-ID: <48816A43.1050903@lwfinger.net> (sfid-20080719_061507_706267_D28CDDF2)
Date: Fri, 18 Jul 2008 23:14:59 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <200807182142.59921.herton@mandriva.com.br>
In-Reply-To: <200807182142.59921.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> 
> I did some tests here and statistics are better now. I only couldn't use 
> latest wireless-testing because something of latest changes broke 
> communication, I couldn't scan/associate anymore, but using wireless-testing 
> head at d61f20889de4978ed87d2a37d6f27147faec22d1 plus later anaparam*off 
> change, with your patch I can confirm the better statistics, later I'll try 
> to find what in wireless-testing broke here, I didn't have time to look into 
> this today.

What platform are you using? I'm on x86_64 and the latest one works for me. At 
least you won't have that many commits to bisect.

Larry
