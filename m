Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:58514 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209Ab1JGVRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Oct 2011 17:17:38 -0400
Received: by mail-bw0-f51.google.com with SMTP id zu17so4835645bkb.38
        for <linux-wireless@vger.kernel.org>; Fri, 07 Oct 2011 14:17:36 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: remove warning message during IBSS Tx
From: Luciano Coelho <coelho@ti.com>
To: Shahar Lev <shahar@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
References: <1318004245-18347-1-git-send-email-shahar@wizery.com>
	 <1318004434.3988.16.camel@jlt3.sipsolutions.net>
	 <CANCvt+6JkxnE6Z7soUuhQSbzpxuxYUNC7z0vv+jn-sH+jpY4Qg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 08 Oct 2011 00:17:33 +0300
Message-ID: <1318022253.3549.108.camel@cumari> (sfid-20111007_231740_944199_9565422A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-10-07 at 23:03 +0200, Shahar Lev wrote: 
> On Fri, Oct 7, 2011 at 6:20 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> > Maybe you should also change that? :-)
> 
> Consider it added to our collective TODO.

Well, the fix is probably supposed to be done in mac80211, instead of
hiding the bug by removing the warning, isn't it?

-- 
Cheers,
Luca.

