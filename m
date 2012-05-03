Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:47321 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586Ab2ECUWO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2012 16:22:14 -0400
Received: by yhmm54 with SMTP id m54so2184009yhm.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 13:22:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336073962.5167.18.camel@jlt3.sipsolutions.net>
References: <1335820832-18887-1-git-send-email-ashok@cozybit.com>
 <1335820832-18887-2-git-send-email-ashok@cozybit.com> <1336073962.5167.18.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Thu, 3 May 2012 13:21:52 -0700
Message-ID: <CACcxo+rYCuMW3c+W1ONyh7deihLcE21J_WyU2bsUB4Mk+Zo-bg@mail.gmail.com> (sfid-20120503_222217_840159_95C386D7)
Subject: Re: [PATCH v2 2/4] mac80211: Implement HT mixed protection mode
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	javier@cozybit.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 3, 2012 at 12:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-04-30 at 14:20 -0700, Ashok Nagarajan wrote:
>
>> +/** mesh_set_ht_prot_mode - set correct HT protection mode
>
> I think you need a newline before the function name, but this isn't
> really valid kernel-doc anyway so please just don't use **
>
Noted.
>> + *
>> + * Section 9.23.3.5 of IEEE 80211s standard
>
> There's no 80211s standard. 802.11s is an amendment, please correct the
> reference to the -2012 version.
>
Noted.
>> +     rcu_read_lock();
>> +     list_for_each_entry_rcu(sta, &local->sta_list, list) {
>> +             if (sdata == sta->sdata &&
>> +                 sta->plink_state == NL80211_PLINK_ESTAB) {
>
> there would be less indentation if you'd add a continue for the mismatch
> cases :-)
>
> johannes
>

Thank you,
Ashok
