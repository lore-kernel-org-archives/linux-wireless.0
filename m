Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:60100 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3BGJTw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 04:19:52 -0500
Received: by mail-wi0-f182.google.com with SMTP id hi18so2586867wib.9
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2013 01:19:50 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1360225230.8038.1.camel@jlt4.sipsolutions.net>
References: <7384f4ddc838247a0f467708d66baa8c@posedge.com> <1360225230.8038.1.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 7 Feb 2013 14:49:29 +0530
Message-ID: <CABPxzYLnWjxtN_c1sFXpA3Ye9ZNvQgV1dU0z=59j0WqgM-rUpg@mail.gmail.com> (sfid-20130207_101958_199772_BFA90AFB)
Subject: Re: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: chaitanyatk@posedge.com, linux-wireless@vger.kernel.org,
	maheshp@posedge.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 7, 2013 at 1:50 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2013-02-07 at 00:01 -0800, chaitanyatk@posedge.com wrote:
>

> Hmm. I'm not exactly happy with using (one of) the last control flag for
> a pure debug facility.
>
Hmm...initially i tried to add qos header in the debugfs itself but to avoid
code redundancy went with the TX_CTL. But in either case we need some kind
of flag to skip adding the qos header by mac80211 (or) to set the AMSDU
bit in the qos control header.


> All those spurious whitespace changes just make the patch appear
> longer ... :)
>
Right, will take care of those along with some line wrapping issues while
submitting the patch.
