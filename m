Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f208.google.com ([209.85.217.208]:60817 "EHLO
	mail-gx0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbZCXUtC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Mar 2009 16:49:02 -0400
Received: by gxk4 with SMTP id 4so6906733gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 24 Mar 2009 13:49:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <871vsmrekh.fsf@litku.valot.fi>
References: <c03d7e680903240959s51aa4864uaad281bd7487e823@mail.gmail.com>
	 <871vsmrekh.fsf@litku.valot.fi>
Date: Tue, 24 Mar 2009 16:48:59 -0400
Message-ID: <c03d7e680903241348x27363902m764c25a9a439d419@mail.gmail.com> (sfid-20090324_214907_712583_E14D9763)
Subject: Re: Adhoc-demo support in mac80211
From: ming li <mingli@cs.umass.edu>
To: Kalle Valo <kalle.valo@iki.fi>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

The adhoc-demo mode is also called pseudo-adhoc mode. It is simply the
ad-hoc mode without control pkts. It does not probe for or associate
to adjacent adhoc networks. The user has to set all the nodes to the
same channel manually. The good thing of adhoc-demo is that it does
not have the beaconing overhead or the IBSS merging/splitting problem.

We used adhoc-demo mode under madwifi for long time and it worked
perfectly. Now we have to shift to ath9k but found out the mode is not
supported. I am just wondering if there is an easy way to hack adhoc
mode to disable beaconing and association.

Thanks,

Ming


On Tue, Mar 24, 2009 at 1:55 PM, Kalle Valo <kalle.valo@iki.fi> wrote:
> ming li <mingli@cs.umass.edu> writes:
>
>> I am wondering how hard it is to add support for ahdemo mode in mac80211.
>> My understanding of ahdemo is that it does not have the beacons or the
>> association process as in adhoc mode.
>
> Can you provide more information about this Adhoc-demo mode? I have
> never heard of it.
>
> --
> Kalle Valo
>
