Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58415 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab2FKRZh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jun 2012 13:25:37 -0400
Received: by obbtb18 with SMTP id tb18so7001964obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2012 10:25:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1339430102.4520.30.camel@jlt3.sipsolutions.net>
References: <4FD28ED7.6070506@xenotime.net> <1339229158.4539.4.camel@jlt3.sipsolutions.net>
 <1339229241.4539.5.camel@jlt3.sipsolutions.net> <4FD61395.8030901@xenotime.net>
 <1339430102.4520.30.camel@jlt3.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Mon, 11 Jun 2012 10:25:17 -0700
Message-ID: <CACcxo+rSFKaYYrJ6c4DT9wiK3iOY1tobEGZ7NyXOOJK+V8kXcg@mail.gmail.com> (sfid-20120611_192540_430254_21678107)
Subject: Re: kernel-doc warnings (3.5-rc1)
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
	linux-wireless@vger.kernel.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Randy and Johannes,

I have sent a patch adding kernel-docs to these variables just now.

Thanks,
Ashok

On Mon, Jun 11, 2012 at 8:55 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-06-11 at 08:49 -0700, Randy Dunlap wrote:
>
>> There are still 2 warnings from sta_info.h after applying
>> your patch:
>>
>> Warning(net/mac80211/sta_info.h:384): No description found for parameter 't_offset_setpoint'
>> Warning(net/mac80211/sta_info.h:384): No description found for parameter 'ch_type'
>
> Right, I wasn't sure what the descriptions should be so asked Javier &
> team to address those.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
