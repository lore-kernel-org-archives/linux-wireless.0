Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:46011 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbYJVHmi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Oct 2008 03:42:38 -0400
Received: by wf-out-1314.google.com with SMTP id 27so2899076wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2008 00:42:37 -0700 (PDT)
Message-ID: <eb3ff54b0810220042y43ea248qba1064a3eedf85b1@mail.gmail.com> (sfid-20081022_094253_296914_B536BE89)
Date: Wed, 22 Oct 2008 09:42:37 +0200
From: "Rami Rosen" <ramirose@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [PATCH ] mac80211: check return value of dev_alloc_skb() in ieee80211_sta_join_ibss().
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <1224660978.28639.27.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <eb3ff54b0810220000p71a54f53ped88651b62c6d35c@mail.gmail.com>
	 <1224660978.28639.27.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Do we want to continue as usual if dev_alloc_skb() in theis method fails?

Regards,
Rami

On Wed, Oct 22, 2008 at 9:36 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2008-10-22 at 09:00 +0200, Rami Rosen wrote:
>> This patch adds a check on the return value of dev_alloc_skb() in
>> ieee80211_sta_join_ibss()
>> in net/mac80211/mlme.c.
>
> What's wrong with the current code?
>
>
>> +               return -1;
>
> don't return -1, return meaningful error values.
>
> johannes
>
