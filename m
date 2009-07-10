Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f218.google.com ([209.85.220.218]:36486 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbZGJLRd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jul 2009 07:17:33 -0400
Received: by fxm18 with SMTP id 18so800638fxm.37
        for <linux-wireless@vger.kernel.org>; Fri, 10 Jul 2009 04:17:31 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] mac80211: monitor the connection
References: <1247186507.1905.14.camel@johannes.local>
	<1247187640.1905.16.camel@johannes.local>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Fri, 10 Jul 2009 14:17:29 +0300
In-Reply-To: <1247187640.1905.16.camel@johannes.local> (Johannes Berg's message of "Fri\, 10 Jul 2009 03\:00\:40 +0200")
Message-ID: <87eiso23ee.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> With the recent MLME rework I accidentally removed the connection
> monitoring code. In order to add it back, this patch will add new
> code to monitor both for beacon loss and for the connection actually
> working, with possibly separate triggers.
>
> When no unicast frames have been received from the AP for (currently)
> two seconds, we will send the AP a probe request.

I think this is too short, but we can change it later. 

I quickly looked at the patch and it looks ok for me. Unfortunately I
can't test it right now because N800 support is broken in 2.6.31. I'm
fixing that currently.

-- 
Kalle Valo
