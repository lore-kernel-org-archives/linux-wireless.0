Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47548 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751803AbaEWJcB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:32:01 -0400
Message-ID: <1400837508.4358.18.camel@jlt4.sipsolutions.net> (sfid-20140523_113206_344792_234AE64A)
Subject: Re: [PATCH v6 1/6] mac80211: introduce switch_vif_chanctx op
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Fri, 23 May 2014 11:31:48 +0200
In-Reply-To: <CA+BoTQmBSjFQXUeCFu9_8-99xXfJaCRGAFmNDxf6GqVfh3Kqaw@mail.gmail.com> (sfid-20140523_111010_653635_9D85C458)
References: <1400767676-15994-1-git-send-email-michal.kazior@tieto.com>
	 <1400767676-15994-2-git-send-email-michal.kazior@tieto.com>
	 <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmVHFCMcx02RN2+J7zcGZbWyypDcNQgGiBSXxyuc_iDYQ@mail.gmail.com>
	 <1400835067.4358.5.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmBSjFQXUeCFu9_8-99xXfJaCRGAFmNDxf6GqVfh3Kqaw@mail.gmail.com>
	 (sfid-20140523_111010_653635_9D85C458)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 11:10 +0200, Michal Kazior wrote:

> > You could either use multiple arrays, or I guess you could even pack a
> > struct into the array, no?
> 
> Packing is not a problem - reading/using is. How do you print an array
> of structs in a trace? I think I've played around this a little but
> gave up for some reason I don't remember anymore.

Oh, you can't print it, you'd have to have a userspace plugin for
trace-cmd to do that.

johannes

