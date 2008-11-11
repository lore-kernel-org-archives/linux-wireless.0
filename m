Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:49373 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751160AbYKKRBL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 12:01:11 -0500
Message-ID: <4919BA54.8040802@lwfinger.net> (sfid-20081111_180115_005740_B33B7E62)
Date: Tue, 11 Nov 2008 11:01:08 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
CC: Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org
Subject: Re: throughput problem/bisect with rtl8187B
References: <992048.28671.qm@web23108.mail.ird.yahoo.com>
In-Reply-To: <992048.28671.qm@web23108.mail.ird.yahoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hin-Tak Leung wrote:
> --- On Tue, 11/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
> 
> <snipped>
>> Lets try to identify what part is broken, I guess is this,
>> can you try this
>> patch on latest wireless-testing?
> 
> Tried it, no improvement. 
> 
> Can you /did you see any problem similiar to mine with throughput on your system(s)?

I may see a slight improvement with the patch. Throughput using sftp goes from
386 KB/s to 460 KB/s when I put in the patch, but there is some jitter and that
change may not be significant.

What rate-setting method are you using? I'm using "pid", which rapidly goes to
54 Mb/s on my device. I tried using minstrel and found that it gets an
occasional burst of speed, but that it usually stays at 1 Mb/s.

Larry
