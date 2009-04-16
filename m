Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:65230 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZDPKZu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 06:25:50 -0400
Received: by bwz17 with SMTP id 17so313630bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 16 Apr 2009 03:25:47 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ANN] iw: v0.9.12
References: <E1LrX4n-0007Z2-7S@sipsolutions.net>
	<1239877031.9737.15.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 16 Apr 2009 13:25:46 +0300
In-Reply-To: <1239877031.9737.15.camel@johannes.local> (Johannes Berg's message of "Thu\, 16 Apr 2009 12\:17\:11 +0200")
Message-ID: <87zleg99p1.fsf@litku.valot.fi> (sfid-20090416_122552_931373_431161D6)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

>> Johannes Berg -  add plain "scan" command that triggers, waits and dumps
>
> So now use
>
> 	iw dev wlan0 scan
>
> instead of trigger/dump!

Oh, nice usability improvement. Thank you!

/me doesn't like the trigger command

-- 
Kalle Valo
