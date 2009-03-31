Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:65446 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZCaMRe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 08:17:34 -0400
Received: by fxm2 with SMTP id 2so2404421fxm.37
        for <linux-wireless@vger.kernel.org>; Tue, 31 Mar 2009 05:17:32 -0700 (PDT)
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Jason Andryuk <jandryuk@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] at76_usb: convert to use linux/ieee80211.h
References: <20090222120434.20821.88974.stgit@tikku>
	<20090331040147.GA15550@bombadil.infradead.org>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Tue, 31 Mar 2009 15:17:30 +0300
In-Reply-To: <20090331040147.GA15550@bombadil.infradead.org> (Kyle McMartin's message of "Tue\, 31 Mar 2009 00\:01\:47 -0400")
Message-ID: <87ab71sx7p.fsf@litku.valot.fi> (sfid-20090331_141745_028976_1D090C02)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kyle McMartin <kyle@mcmartin.ca> writes:

> On Sun, Feb 22, 2009 at 02:04:34PM +0200, Kalle Valo wrote:
>> Jason Andryuk noticed that at76_usb won't compile with current
>> wireless-testing tree. This is because net/ieee80211.h was missing.
>> 
>> net/ieee80211.h will be removed soon and at76_usb won't compile then that
>> happens. Preprare for that by using instead linux/ieee80211.h and copying
>> some structures not available.
>> 
>> Signed-off-by: Kalle Valo <kalle.valo@iki.fi>
>
> Ping? This is still an issue in git head... Should probably go in
> via the staging tree...

At least the patch is in Greg's staging directory:

http://kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-05-staging/staging-at76_usb-convert-to-use-linux-ieee80211.h.patch

I would assume that Greg pushes it forward at some point.

-- 
Kalle Valo
