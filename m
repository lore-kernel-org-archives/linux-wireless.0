Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:34023 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbXITMWP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 08:22:15 -0400
To: "Nick Kossifidis" <mickflemm@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR5006 - should it work?
References: <m3odg0dji3.fsf@maximus.localdomain>
	<40f31dec0709190755h5ea62e0cv578f2a5ed0788d80@mail.gmail.com>
	<m3ir66s1zn.fsf@maximus.localdomain>
	<40f31dec0709191939l6f99b59gd31d5291057692a2@mail.gmail.com>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Thu, 20 Sep 2007 14:22:13 +0200
In-Reply-To: <40f31dec0709191939l6f99b59gd31d5291057692a2@mail.gmail.com> (Nick Kossifidis's message of "Thu, 20 Sep 2007 05:39:33 +0300")
Message-ID: <m3wsul5xxm.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Nick Kossifidis" <mickflemm@gmail.com> writes:

>> Is it possible that a signal which shows as 20/127 on 5004X
>> is too weak for 5006X to be detected by scanning?
>
> Nope it's fine, it might be that 5006X's RF part is not initialized
> propertly so it doesn't "hear" 5004X.

Thanks. I will try the binary HAL to see if it changes anything,
there is always a chance the cards are damaged (not very likely,
I have 4 AR5006X).
-- 
Krzysztof Halasa
