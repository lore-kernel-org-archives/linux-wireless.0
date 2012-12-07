Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53569 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LGWpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 17:45:13 -0500
Received: by mail-pa0-f46.google.com with SMTP id bh2so772405pad.19
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 14:45:13 -0800 (PST)
Message-ID: <50C27177.30309@cozybit.com> (sfid-20121207_234518_845103_8ADFFDC3)
Date: Fri, 07 Dec 2012 14:45:11 -0800
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: devel@lists.open80211s.org
CC: Bob Copeland <me@bobcopeland.com>,
	Max Filippov <jcmvbkbc@gmail.com>, johannes@sipsolutions.net,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	linux-wireless@vger.kernel.org,
	Mike Krinkin <krinkin.m.u@gmail.com>
Subject: Re: [RFCv3 4/5] mac80211: mesh power save basics
References: <1354918443-3076-1-git-send-email-marco@cozybit.com> <1354918443-3076-5-git-send-email-marco@cozybit.com> <20121207224110.GE535@localhost>
In-Reply-To: <20121207224110.GE535@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/07/2012 02:41 PM, Bob Copeland wrote:
> On Fri, Dec 07, 2012 at 02:14:02PM -0800, Marco Porsch wrote:
>> +void ieee80211_mps_set_sta_local_pm(struct sta_info *sta,
>> +				    enum nl80211_mesh_power_mode pm,
>> +				    u32 delay);
>> +void ieee80211_mps_sta_local_pm_timer(unsigned long data);
>> +void ieee80211_msp_set_frame_flags(struct ieee80211_sub_if_data *sdata,
>> +				   struct sta_info *sta,
>> +				   struct ieee80211_hdr *hdr);
>
> Does "msp" mean anything, or is it supposed to be mps like the others?

Oh, snap. That was a typo during refactoring. Thanks for noticing!

