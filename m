Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:54123 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935Ab2K0RBd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Nov 2012 12:01:33 -0500
Received: by mail-wi0-f170.google.com with SMTP id hq7so4020053wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 27 Nov 2012 09:01:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1354032428.9576.9.camel@jlt4.sipsolutions.net>
References: <1354031029-7956-1-git-send-email-helmut.schaa@googlemail.com>
	<1354032428.9576.9.camel@jlt4.sipsolutions.net>
Date: Tue, 27 Nov 2012 18:01:31 +0100
Message-ID: <CAGXE3d99FMS-dTUe2jUp4_qi+783whLCWnWnRNgXcVE0KGDnng@mail.gmail.com> (sfid-20121127_180136_996230_CA90BD12)
Subject: Re: [PATCH] mac80211: Reject setting masked mac addresses
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2012 at 5:07 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Tue, 2012-11-27 at 16:43 +0100, Helmut Schaa wrote:
>
>> +     if (!is_zero_ether_addr(local->hw.wiphy->addr_mask)) {
>> +             m = local->hw.wiphy->perm_addr;
>
> I'm not sure I like using perm_addr here. You might actually want to use
> a totally different address, but fit all of them into the mask, no?

Agreed, I'll respin.

Thanks,
Helmut
