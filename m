Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:43692 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751614AbbALJHt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 04:07:49 -0500
Received: by mail-wi0-f180.google.com with SMTP id n3so13094274wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 01:07:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1420449724.1898.1.camel@sipsolutions.net>
References: <1410467723-2550-1-git-send-email-vadim4j@gmail.com>
	<1411075535.2034.5.camel@jlt4.sipsolutions.net>
	<20141014121627.GA5115@angus-think.lan>
	<1413798437.10246.12.camel@jlt4.sipsolutions.net>
	<128188DF-5A9B-47A5-8A89-974CF7CF9064@holtmann.org>
	<1413802344.10246.20.camel@jlt4.sipsolutions.net>
	<CAMw6YJKLWQmT-fqg1QLDHbCxnpxWyJUSX+wvOB_pFyE=8HfSfQ@mail.gmail.com>
	<1420449724.1898.1.camel@sipsolutions.net>
Date: Mon, 12 Jan 2015 11:07:48 +0200
Message-ID: <CAMw6YJJgPJw7jizR=Qe_2SOK=S0UKrm9AyE7MHUg1-wODEab2g@mail.gmail.com> (sfid-20150112_100756_220356_EA661295)
Subject: Re: [PATCH net-next] Allow to set net namespace for wireless device
 via RTM_LINK
From: Vadim Kochan <vadim4j@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 5, 2015 at 11:22 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2014-12-24 at 11:48 +0200, Vadim Kochan wrote:
>
>>     1) Set NETIF_F_NETNS_LOCAL for phy wireless device only if there
>> is at least one virtual interface which was created on it
>
> You mean at least two? I'd think the behaviour becomes hard to predict,
> but I guess ultimately that'd be somewhat reasonable.
>
>>     2) What about to inherit netns for newer created interfaces from
>> the phy device ?
>
> Hmm? This already happens - a given phy is only in a single netns and
> all interfaces must be created in the same netns.
>
> johannes
>
Hi,

Would you please explain why wireless devs related to the same phy
can't live in separated network namespaces ?

Thanks,
