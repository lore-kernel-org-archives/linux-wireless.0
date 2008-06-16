Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.178]:32390 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827AbYFPNGv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 09:06:51 -0400
Received: by wa-out-1112.google.com with SMTP id j37so4333872waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jun 2008 06:06:50 -0700 (PDT)
Message-ID: <1ba2fa240806160606g379747aam473bd4a3620ce72@mail.gmail.com> (sfid-20080616_150700_972370_9D4C2F1A)
Date: Mon, 16 Jun 2008 16:06:50 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH 2/2 V2] mac80211: 11h - Handling measurement request
Cc: linville@tuxdriver.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	"Assaf Krauss" <assaf.krauss@intel.com>
In-Reply-To: <1213620760.3803.30.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213615217-10777-1-git-send-email-tomas.winkler@intel.com>
	 <1213620760.3803.30.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 16, 2008 at 3:52 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2008-06-16 at 14:20 +0300, Tomas Winkler wrote:
>> From: Assaf Krauss <assaf.krauss@intel.com>
>>
>> This patch handles the 11h measurement request information element.
>> This is minimal requested implementation - refuse measurement.
>>
>> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
>> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>
> Looks fine to me.
>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>
>
>> +/* measurement */
>> +#define IEEE80211_SPCT_MSR_RPRT_MODE_LATE    (1<<0)
>> +#define IEEE80211_SPCT_MSR_RPRT_MODE_INCAPABLE       (1<<1)
>> +#define IEEE80211_SPCT_MSR_RPRT_MODE_RFEUSED (1<<2)
>                                        ^^^^^^^ typo
>
>> +     msr_report->u.action.u.measurement.msr_elem.mode |=
>> +                     IEEE80211_SPCT_MSR_RPRT_MODE_RFEUSED;
>
> search & replace? :)
>
Oh, okay will send V3 :(

> johannes
>
