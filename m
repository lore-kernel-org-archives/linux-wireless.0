Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38570 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691AbbFASTr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 14:19:47 -0400
Received: by igbjd9 with SMTP id jd9so68359661igb.1
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 11:19:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
 <1390426022.4334.50.camel@jlt4.sipsolutions.net> <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Mon, 1 Jun 2015 23:49:25 +0530
Message-ID: <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com> (sfid-20150601_201950_224485_72F9F022)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS mode
 for frames sent using Nss>1.
To: Johannes Berg <johannes@sipsolutions.net>,
	Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 30, 2014 at 11:48 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Thu, Jan 23, 2014 at 2:57 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>>
>> On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:
>>
>> > +             if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
>> > +                     minstrel_mcs_groups[i].streams > 1) {
>> > +                     mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
>> > +             } else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
>> > +                     minstrel_mcs_groups[i].streams > 1) {
>>
>> Your indentation is off inside the if statements. I'll have to wait for
>> nbd to review the patch itself, I guess.
>>
> Felix,
>
>  Any comments other than the indentation? If no, will send in the
> v2 with indentation fixed.

Was checking my old submissions. This was marked as "Not Applicable" in
patchwork.

Felix/Johannes,

Can you please explain to me the meaning of the status "Not Applicable"?

Regards,
Chaitanya T K.
-- 
Thanks,
Regards,
Chaitanya T K.
