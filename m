Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:61380 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808Ab2HTSF3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Aug 2012 14:05:29 -0400
Received: by dady13 with SMTP id y13so2345686dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 20 Aug 2012 11:05:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1345461929.4459.15.camel@jlt3.sipsolutions.net>
References: <1344561340-32409-1-git-send-email-thomas@cozybit.com> <1345461929.4459.15.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Mon, 20 Aug 2012 11:05:08 -0700
Message-ID: <CAG6hwVOmr-a0KNDqiGGNJy=nDJvDFZ4TJ93uzzbbHnTn=TRxEQ@mail.gmail.com> (sfid-20120820_200532_987572_57CDF6C5)
Subject: Re: [PATCH v2 1/2] mac80211: use skb_queue_walk() in mesh_path_assign_nexthop
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 20, 2012 at 4:25 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2012-08-09 at 18:15 -0700, Thomas Pedersen wrote:
>> Since all we really want is just to iterate over all skbs, do just that
>> and avoid (de)queueing to a clusmy tmpq.
>
> Ok ... replaced with these, what was the difference anyway? :)

Accidentally left in an XXX :)

Thanks,
Thomas
