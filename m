Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:45762 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbYGWDtU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jul 2008 23:49:20 -0400
Message-ID: <4886AA3B.3000406@lwfinger.net> (sfid-20080723_054925_441813_D5AD83E5)
Date: Tue, 22 Jul 2008 22:49:15 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak.leung@gmail.com>,
	Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Subject: Re: [RFC/RFT] rtl8187: Improve wireless statistics for RTL8187B
References: <487f5f20.2lT57D3i0q99wrfY%Larry.Finger@lwfinger.net> <200807221613.34434.herton@mandriva.com.br> <3ace41890807221525r67716ea0r251068df773fe53f@mail.gmail.com> <200807221940.20009.herton@mandriva.com.br>
In-Reply-To: <200807221940.20009.herton@mandriva.com.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> Em Tuesday 22 July 2008 19:25:20 Hin-Tak Leung escreveu:
>> Disabling power management doesn't improve the situation with latest
>> wireless testing
>> for me. I had a look at the change and it seems simple enough.
> 
> Yes, I also looked at the commit, it's simple and I can't see how it's 
> affecting transmission in my case. It's bizarre and I must be doing something 
> wrong.

I just found that my RTL8187B doesn't work with the current wireless-testing 
either. I don't know why I thought otherwise earlier. If I do a 'git checkout 
d61f20889de4978ed8', which is my patch to change the detection of early 8187B, 
then it works fine. I'll do a bisection to see if my system agrees that the wext 
power patch is the problem.

I'll let you know what I find.

Larry
