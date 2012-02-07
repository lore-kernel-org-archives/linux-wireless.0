Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:46383 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756226Ab2BGUdr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Feb 2012 15:33:47 -0500
Subject: Re: REGRESSION: crash in wireless-testing smoketest
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4F315E7E.7040203@broadcom.com>
References: <4F313815.3020107@broadcom.com>
	 ( sfid-20120207_154219_853529_011888C8) <4F313C53.2040604@sipsolutions.net>
	 <4F315E7E.7040203@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 21:32:56 +0100
Message-ID: <1328646776.4223.0.camel@jlt3.sipsolutions.net> (sfid-20120207_213352_585517_C487E8A7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-02-07 at 18:25 +0100, Arend van Spriel wrote:

> >> The brcmsmac driver does not provide a sta_remove callback. I suspect
> >> that is causing the issue here. Can you confirm?
> > 
> > I'm on a business trip right now, but I can take a look. Did it really 
> > *crash*? You said so in the subject but have no crash data.
> > 
> > johannes
> > 
> 
> The logs did not catch it before the crash. I dug a bit deeper and it
> does not seem the missing sta_remove is a problem as drv_sta_remove
> checks the function pointer being non-NULL before using it.
> 
> Can you recommend a kernel hacking option so the log may give a better clue?

Not really, I suppose this is automated and you don't capture the
(serial) console?

johannes

