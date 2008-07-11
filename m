Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:38479 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472AbYGKM7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Jul 2008 08:59:51 -0400
Received: by rv-out-0506.google.com with SMTP id k40so4414521rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 11 Jul 2008 05:59:51 -0700 (PDT)
Message-ID: <1ba2fa240807110559x5d4bbbcx63bdf007bb99e067@mail.gmail.com> (sfid-20080711_150005_428556_D7C733C4)
Date: Fri, 11 Jul 2008 15:59:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: removing STAs while aggregation is in effect?
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1215770111.3483.112.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1215770111.3483.112.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 11, 2008 at 12:55 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi Ron,
>
> Quick question: I was looking through the new tx queue rework davem did
> and couldn't immediately tell whether or not the right thing happens
> when a STA is removed while aggregation is in effect. Say mac80211 is
> operating as an AP and a STA disassociates in the middle of an
> aggregation session, I can see nothing that guarantees the aggregation
> queue will be drained and returned to the pool etc.
>
> Am I missing something?
>
We found that too. We will soon release dissociation patches for review.
Tomas
> johannes
>
