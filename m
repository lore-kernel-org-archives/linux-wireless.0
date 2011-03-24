Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48157 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932915Ab1CXXAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Mar 2011 19:00:48 -0400
Received: by iwn34 with SMTP id 34so428138iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 24 Mar 2011 16:00:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300266526.3761.7.camel@jlt3.sipsolutions.net>
References: <507B31BE-2066-4434-870D-108F7DF912A6@cs.washington.edu>
 <1300263716.3761.1.camel@jlt3.sipsolutions.net> <AANLkTikir41uU_fG91w68D4JyFMPcFYKW4QFg-Ag_EUK@mail.gmail.com>
 <1300265348.3761.3.camel@jlt3.sipsolutions.net> <AANLkTi=8th1NyjQE4zvVcS21Dba3Ku_WhnwQS0ZR9+EH@mail.gmail.com>
 <1300266526.3761.7.camel@jlt3.sipsolutions.net>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Thu, 24 Mar 2011 16:00:27 -0700
Message-ID: <AANLkTi=3jby9okMh7tggNdQ3xzHX=FXDu+3e8xu155f0@mail.gmail.com>
Subject: Re: [PATCH] mac80211: fix aggregation frame release during timeout
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 16, 2011 at 2:08 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Right. I'm happy with your change anyhow, but I think I'd prefer if you
> moved the skipped test to the front (i.e. skipped && time...) since it's
> much cheaper. Then again I guess it doesn't really matter here...

I think this wasn't picked up by John.  I'm about to re-send with the
skipped test moved.

Dan
