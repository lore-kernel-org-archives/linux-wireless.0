Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:12721 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758637AbZBEP7Q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 10:59:16 -0500
Received: by mu-out-0910.google.com with SMTP id i10so231078mue.1
        for <linux-wireless@vger.kernel.org>; Thu, 05 Feb 2009 07:59:14 -0800 (PST)
Subject: Re: [ath5k-devel] [PATCH 5/5] ath5k: Update reset code
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: Nick Kossifidis <mick@madwifi-project.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, jirislaby@gmail.com
In-Reply-To: <20090205154532.M30551@bobcopeland.com>
References: <20090131023147.GE3342@makis> <20090204215706.GA5651@makis>
	 <20090205154532.M30551@bobcopeland.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 17:59:10 +0200
Message-Id: <1233849550.18717.3.camel@maxim-laptop> (sfid-20090205_165937_551567_1E32A94B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-02-05 at 10:51 -0500, Bob Copeland wrote:
> On Wed, 4 Feb 2009 23:57:06 +0200, Nick Kossifidis wrote
> > * Update reset and sync with HALs
> >  * Clean up eeprom settings and tweaking of initvals and put them on
> separate functions
> >  * Set/Restore 32KHz ref clk operation
> >  * Add some more documentation
> >  TODO: Spur mitigation, tpc, half/quarter rate, compression etc
> > 
> >  v2: Address comments from Bob and Felix and fix RSSI threshold bug
> >  introduced on the first version of the patch
> > 
> >  Signed-Off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> This works much better, except I still get some hard hangs 
> occasionally.  Doesn't appear to be bmiss storm this time.  I did it 
> with a VT up and didn't get an oops; I guess I'll try a serial console
> or some printks.
> 
> I could trigger it via a few suspend-resume cycles, so I guess it's the
> reset from ath5k_init().  Did you still have any problems with the 2425?
> 

It also work better here, I didn't yet see these hangs, but nether I did
many suspend/resume cycles, so I'll take an another look.

But what I did see is that gain/noise timeouts still happen.
in exactly same way.

Best regards,
	Maxim Levitsky

