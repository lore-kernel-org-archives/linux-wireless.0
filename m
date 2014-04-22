Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from stator.leun.net ([85.214.203.199]:35535 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756385AbaDVUBL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 16:01:11 -0400
Date: Tue, 22 Apr 2014 21:48:24 +0200
From: Michael Leun <lkml20140418@newton.leun.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Arik Nemtsov <arik@wizery.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Subject: Re: [PATCH 0/2] cfg80211: two reg fixes
Message-ID: <20140422214824.6b4e531c@xenia.leun.net> (sfid-20140422_220118_808429_A88D7F96)
In-Reply-To: <CAB=NE6UCS3ZSE3CQ_98vBHQqZRR31PwF61_G+UZ-mEp=WqEDeQ@mail.gmail.com>
References: <1398137975-14275-1-git-send-email-mcgrof@do-not-panic.com>
	<20140422180003.6438dbb7@xenia.leun.net>
	<CAB=NE6URp2S9rhVr2cqT+4VOj50m+q0o1rVRehCZvcUtNwTVVw@mail.gmail.com>
	<20140422184824.74973bb3@xenia.leun.net>
	<CAB=NE6W64b5VS5pTnxrcRRkRdje6h_hQcGmF9jUiXO55b+nHRw@mail.gmail.com>
	<20140422193029.2d81fac5@xenia.leun.net>
	<CAB=NE6UCS3ZSE3CQ_98vBHQqZRR31PwF61_G+UZ-mEp=WqEDeQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 22 Apr 2014 10:38:54 -0700
"Luis R. Rodriguez" <mcgrof@do-not-panic.com> wrote:


> Yeah we don't want that 2nd patch, your issue seems like a race on the
>  wiphy during suspend, which is very surprising, specially that no one
> else would have picked up on this before. I'll go build v3.14.1 and
> reproduce with rtcwake -m mem -s 30.

Suspend is only one thing that reliably triggers this. I've also seen
the machine to barf during normal operation, but only since 3.14.

Hope you can reproduce, if not I maybe have to think about how to crank
up some remote access for you...

-- 
MfG,

Michael Leun

