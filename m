Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.176]:44055 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624AbYKXWcW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2008 17:32:22 -0500
Received: by ik-out-1112.google.com with SMTP id c29so1839234ika.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2008 14:32:19 -0800 (PST)
Message-ID: <492B2B74.7040404@gmail.com> (sfid-20081124_233226_651848_03CE4F5B)
Date: Mon, 24 Nov 2008 17:32:20 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: John Linville <linville@tuxdriver.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: wireless-regdb: flaw in general functionality
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First of all I would like to say that the entire idea and function 
behind crda is vastly improved from the old regulatory settings hard 
coded in the kernel.  In light of this, however, we all seem to be 
avoiding a very clear part of reality.

crda and the regulatory database restrain the channels that a person can 
legally transmit on based on their (presumed) current regulatory 
legislation.  Unfortunately, when I learned about radios I was taught 
that radios can RECEIVE as well as transmit.  In fact, in the USA (the 
country I live in and hence where I am most familiar with the laws) it 
is 100% legal to monitor any frequency that you desire.  crda clearly 
misses that fact and doesn't permit proper legal operation of the radio 
device.

crda and the regulatory database should be modified so that I can use my 
cards in the legal manner prescribed by the FCC (my regulatory body here 
in the USA).

Thanks,
Rick Farina

PS> those of you that are warming up to tell me "it's not legal to 
monitor cell phones" please save the key strokes.  It is not legal to 
modify, buy, sell or create a device that can monitor cell phones, if 
you already own one then it is legal to use, as it always has been and 
always will be. (FYI I've not found a device yet that can hit the cell 
phone bands.) Long ago it was promised that the FCC would never make 
listening against the law, surprisingly they have kept their promise so far.
