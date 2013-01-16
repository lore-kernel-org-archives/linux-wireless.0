Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47159 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757582Ab3APERg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jan 2013 23:17:36 -0500
Received: by mail-wg0-f47.google.com with SMTP id dq11so559504wgb.26
        for <linux-wireless@vger.kernel.org>; Tue, 15 Jan 2013 20:17:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1358248982.4648.1.camel@jlt4.sipsolutions.net>
References: <CABPxzYL1LM-XAAb1RomgcM=O9Ma=KJZcbmEgTA678FSFuT8QMg@mail.gmail.com>
 <1358248982.4648.1.camel@jlt4.sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 16 Jan 2013 09:39:40 +0530
Message-ID: <CABPxzYJciFXV=S7BGWT_V-M8U9ydpiBT8RSJJn35oHQy+zh3aQ@mail.gmail.com> (sfid-20130116_114555_105283_96F7A02B)
Subject: Re: Tx AMSDU Support
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>, nbd@openwrt.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 15, 2013 at 4:53 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
>> Is there any work in progress/planned related to Tx AMSDU logic in mac80211?
>
> At some point Felix was planning to look at this, but I don't think he
> ever did. I guess he'll correct me if I'm wrong.
>
>> Even though only Rx is mandatory, but to test the Rx we need the Tx.
>>
>> I see that the support is there in mwifiex(marvell's) driver. So is
>> there any patent/legal issue before we can implement one?
>
> I'm not aware of any issue. You could probably even take some of that
> code and make it some generic cfg80211 helper library for use by both
> mwifiex and mac80211.
>
> johannes
>

That sounds right, we can at least develop a test helper for doing
that if not a commercial one.

Chaitanya T K.
