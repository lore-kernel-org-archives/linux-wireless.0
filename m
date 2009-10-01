Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:53622 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755653AbZJAHt5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Oct 2009 03:49:57 -0400
Received: by ewy7 with SMTP id 7so7197277ewy.17
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2009 00:50:00 -0700 (PDT)
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: linux-wireless@vger.kernel.org
Subject: Re: unused header file drivers/net/wireless/wl12xx/wl1251_netlink.h?
References: <alpine.LFD.2.00.0909301554001.21753@localhost>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 01 Oct 2009 10:49:56 +0300
In-Reply-To: <alpine.LFD.2.00.0909301554001.21753@localhost> (Robert P. J. Day's message of "Wed\, 30 Sep 2009 15\:55\:26 -0400 \(EDT\)")
Message-ID: <87k4zfr1sr.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Robert P. J. Day" <rpjday@crashcourse.ca> writes:

>   as best i can tell, that header file is entirely unreferenced by
> anything in the tree.  just an observation.

Yes, it's unused. I added it accidentally a long time ago when I
rebased a big pile of patches. I'll send a patch to remove it.

Thanks for reporting this.

-- 
Kalle Valo
