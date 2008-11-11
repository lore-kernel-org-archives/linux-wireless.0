Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:65509 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752010AbYKKTmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2008 14:42:18 -0500
Message-ID: <4919E017.8000301@lwfinger.net> (sfid-20081111_204223_637576_861CAAD9)
Date: Tue, 11 Nov 2008 13:42:15 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
CC: Hin-Tak Leung <hintak_leung@yahoo.co.uk>,
	linux-wireless@vger.kernel.org
Subject: Re: throughput problem/bisect with rtl8187B
References: <992048.28671.qm@web23108.mail.ird.yahoo.com> <200811111634.14786.herton@mandriva.com.br>
In-Reply-To: <200811111634.14786.herton@mandriva.com.br>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Herton Ronaldo Krzesinski wrote:
> On Tuesday 11 November 2008 14:48:52 Hin-Tak Leung wrote:
>> --- On Tue, 11/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:
>>
>> <snipped>
>>> Lets try to identify what part is broken, I guess is this,
>>> can you try this
>>> patch on latest wireless-testing?
>> Tried it, no improvement. 
>>
>> Can you /did you see any problem similiar to mine with throughput on your system(s)?
> 
> Nope, here I can scp a large file from another machine, rate stabilizes at 6M
> with minstrel, transfer rate stays around 400-480KB/s, and drops/fluctuates
> below 400KB/s usually (must be affected by other network traffic, I can't do
> the test now on a clean environment).
> 
> Please check this patch to see if things improve, if not, can you check with
> the patch I posted earlier, "Add conf_tx callback and use it to configure tx
> queues of 8187L/8187B.", if things improve? (I think you already checked, but
> just in case you tested only the rate control related patch)

With patch #2 I get an upload speed of 463 KB/s, which is the same as before.

Hin-tak: If you use "minstrel" as the rate-control algorithm, mac80211 says so.
You are using "pid".

Larry
