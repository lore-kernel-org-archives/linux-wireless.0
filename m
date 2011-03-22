Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:59886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1CVOP2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 10:15:28 -0400
Received: from wpaz29.hot.corp.google.com (wpaz29.hot.corp.google.com [172.24.198.93])
	by smtp-out.google.com with ESMTP id p2MEFRVZ021548
	for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:15:27 -0700
Received: from iwn3 (iwn3.prod.google.com [10.241.68.67])
	by wpaz29.hot.corp.google.com with ESMTP id p2MEDloq031394
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:15:26 -0700
Received: by iwn3 with SMTP id 3so14190363iwn.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:15:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300801030.3746.6.camel@jlt3.sipsolutions.net>
References: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
	<1300801030.3746.6.camel@jlt3.sipsolutions.net>
Date: Tue, 22 Mar 2011 07:15:26 -0700
Message-ID: <AANLkTiktw2FPX8UYOmuf4AXjLrWEM=xsqgnTYjGkytMK@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add station BSS parameters to station
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2011 at 6:37 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-03-21 at 14:32 -0700, Paul Stewart wrote:
>
>> Paul Stewart (4):
>>   nl80211: Add station info flags and intervals
>>   cfg80211: Add station info to station struct
>>   nl80211: Add bss info to station message
>>   mac80211: Add bss info to that exported to station
>
> Also, FWIW, I wouldn't mind if the first three patches were rolled up
> into one, or even all of them for such a fairly simple thing. Not saying
> you need to change it either though.

Thanks for all the good input.  In the future I'll adjust my threshold
for patch breakup accordingly. :-)

--
Paul
