Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:35800 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753808AbbFAVdw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2015 17:33:52 -0400
Received: by iesa3 with SMTP id a3so119404532ies.2
        for <linux-wireless@vger.kernel.org>; Mon, 01 Jun 2015 14:33:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433191009.3505.18.camel@sipsolutions.net>
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
 <1390426022.4334.50.camel@jlt4.sipsolutions.net> <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
 <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com> <1433191009.3505.18.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 2 Jun 2015 03:03:31 +0530
Message-ID: <CABPxzY+eaUB6BY-c71RPxqSThizCM=qzt=K_+4du8zHLrY=_oQ@mail.gmail.com> (sfid-20150601_233357_177756_AC28571B)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS mode
 for frames sent using Nss>1.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2015 at 2:06 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2015-06-01 at 23:49 +0530, Krishna Chaitanya wrote:
>> On Thu, Jan 30, 2014 at 11:48 PM, Krishna Chaitanya
>> <chaitanya.mgit@gmail.com> wrote:
>> > On Thu, Jan 23, 2014 at 2:57 AM, Johannes Berg
>> > <johannes@sipsolutions.net> wrote:
>> >>
>> >> On Wed, 2014-01-22 at 12:27 +0530, Chaitanya T K wrote:
>> >>
>> >> > +             if (sta->smps_mode == IEEE80211_SMPS_DYNAMIC &&
>> >> > +                     minstrel_mcs_groups[i].streams > 1) {
>> >> > +                     mi->tx_flags |= IEEE80211_TX_RC_USE_RTS_CTS;
>> >> > +             } else if (sta->smps_mode == IEEE80211_SMPS_STATIC &&
>> >> > +                     minstrel_mcs_groups[i].streams > 1) {
>> >>
>> >> Your indentation is off inside the if statements. I'll have to wait for
>> >> nbd to review the patch itself, I guess.
>> >>
>> > Felix,
>> >
>> >  Any comments other than the indentation? If no, will send in the
>> > v2 with indentation fixed.
>>
>> Was checking my old submissions. This was marked as "Not Applicable" in
>> patchwork.
>>
>> Felix/Johannes,
>>
>> Can you please explain to me the meaning of the status "Not Applicable"?
>
> This patch is *ancient*, before we actually used patchwork properly ...
Ok, so you want me to send a V2 with the indentation fixed?
(or) shall i wait for Felix's review before sending V2?



-- 
Thanks,
Regards,
Chaitanya T K.
