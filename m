Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:39441 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255AbYLGDE0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 22:04:26 -0500
Received: by ti-out-0910.google.com with SMTP id b6so412026tic.23
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 19:04:24 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18747.15541.811292.500184@localhost.localdomain> (sfid-20081207_040437_042806_640A0EAF)
Date: Sun, 7 Dec 2008 08:32:13 +0530
To: Mats Johannesson <spamcan1@abrasax.se>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as
 root
In-Reply-To: <20081206202237.578b3783@loke.fish.not>
References: <20081206113406.734f1d94@loke.fish.not>
	<18746.37273.989918.333164@localhost.localdomain>
	<20081206180537.717d1791@loke.fish.not>
	<18746.48068.593834.660064@localhost.localdomain>
	<20081206202237.578b3783@loke.fish.not>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mats Johannesson wrote:
> Sorry to say, no change. After root scan telnet gives "no route to
> host" and ping just reports 100% packet loss. But iwconfig keeps
> updating its info regarding link quality and signal strength, like:
> Link Quality=82/100  Signal level:-42 dBm
> 

Which channel are you using ? And is it HT40 ?
Also please post the debug log, you can do 'insmod ath9k debug=0x00002000'
to get a fair amount of debug information.

Thanks.

Sujith
