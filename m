Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:56727 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632AbaDVRYV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:24:21 -0400
Received: by mail-la0-f51.google.com with SMTP id pv20so4672452lab.10
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 10:24:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1398180129.4211.22.camel@jlt4.sipsolutions.net>
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com> <1398180129.4211.22.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 10:24:00 -0700
Message-ID: <CAB=NE6U5=rt+VS4dhrLb-oLun_fw2qSbEQhLYdFnAhUYep791g@mail.gmail.com> (sfid-20140422_192427_870771_0F05D4DA)
Subject: Re: [PATCH] cfg80211: reg: track crda request
To: Johannes Berg <johannes@sipsolutions.net>,
	Sander Eikelenboom <linux@eikelenboom.it>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 22, 2014 at 8:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-04-16 at 12:53 +0200, Janusz Dziedzic wrote:
>> Track CRDA request and handle timeout when no answer
>> from CRDA. This could happen when crda is not available
>> yet (not mounted fs), eg. during OS startup and cfg80211
>> built-in to the kernel.
>> Before we could stuck when processing last request
>> without ability to process current and any further
>> regulatory requests.
>
> Hmm, this doesn't apply now on top of the patches Luis sent. Was this
> the patch that was meant alternatively?

Sorry I failed to pick this up amongst the threads, this one is a
replacement for the my real original 2nd and 3rd patch (2nd in
yesterday's series, but I hadn't redone the 3rd patch from the
original series) but I rather we treat things linearly and see if we
can split this up a bit, as I see this is an evolution of the work
from my original 2nd patch. I'll work on this and send out something
shortly.

  Luis
