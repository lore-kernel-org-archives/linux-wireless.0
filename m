Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:58719 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab3KNPfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Nov 2013 10:35:09 -0500
Received: by mail-lb0-f171.google.com with SMTP id q8so498847lbi.16
        for <linux-wireless@vger.kernel.org>; Thu, 14 Nov 2013 07:35:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1384442962.13941.36.camel@jlt4.sipsolutions.net>
References: <1384366379-25301-1-git-send-email-mcgrof@do-not-panic.com>
 <1384366379-25301-5-git-send-email-mcgrof@do-not-panic.com>
 <1384378096.28806.20.camel@jlt4.sipsolutions.net> <20131114143126.GC19070@garbanzo.do-not-panic.com>
 <1384440519.13941.31.camel@jlt4.sipsolutions.net> <20131114153339.GB30653@garbanzo.do-not-panic.com>
 <1384442962.13941.36.camel@jlt4.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 14 Nov 2013 16:34:47 +0100
Message-ID: <CAB=NE6WX9JV-Lx11iiPHPinDCxy7u-Q--ucQ-9Mjy-nndKTeqQ@mail.gmail.com> (sfid-20131114_163512_849475_A0CF8D39)
Subject: Re: [RFC 4/5] cfg80211: add DFS region capability support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Jouni Malinen <j@w1.fi>, sunitb@qca.qualcomm.com,
	rsunki@qca.qualcomm.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 14, 2013 at 4:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2013-11-14 at 07:33 -0800, Luis R. Rodriguez wrote:
>> > Still doesn't make sense - HANDLE_DFS means "I'll react to radar
>> > detection events and will do the CSA". It has absolutely nothing to do
>> > with DFS regions. Please keep those things separate.
>>
>> How you deal with radar detection is completely dependent on the DFS
>> region, no?
>
> You're missing *my* point :-)
>
> Radar *detection* is region-dependent.
>
> What happens *after* that (announce a channel switch, etc.) isn't at
> all.

Sorry, I misread the documentation then, so HANDLE_DFS *does* not mean
userspace will implement the radar detection in userspace?

  Luis
