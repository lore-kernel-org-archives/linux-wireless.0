Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:44681 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab1JTSIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Oct 2011 14:08:47 -0400
Received: by wwn22 with SMTP id 22so8184418wwn.1
        for <linux-wireless@vger.kernel.org>; Thu, 20 Oct 2011 11:08:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1319133820.20837.0.camel@jlt3.sipsolutions.net>
References: <1319072606-28291-1-git-send-email-thomas@cozybit.com>
	<1319072606-28291-6-git-send-email-thomas@cozybit.com>
	<1319109412.3959.7.camel@jlt3.sipsolutions.net>
	<CAG6hwVMUhJ=nV=6N+DpoagKWJxMjythPYMYCCzEb=mTr6TfytQ@mail.gmail.com>
	<1319133104.17101.5.camel@jlt3.sipsolutions.net>
	<CAG6hwVMmvu5jMQLeOWG2via0wqkHGs=nHSi_mKvgy9U2+m1FXA@mail.gmail.com>
	<1319133820.20837.0.camel@jlt3.sipsolutions.net>
Date: Thu, 20 Oct 2011 11:08:46 -0700
Message-ID: <CAG6hwVOaLp9SdPezdw=aLhKrKpPdp8m5vXf6rySTvCfriaziVw@mail.gmail.com> (sfid-20111020_200850_986757_2705B277)
Subject: Re: [PATCH 5/6] mac80211: add WMM IE to mesh frames
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, anagar6@uic.edu,
	devel@lists.open80211s.org, linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 20, 2011 at 11:03 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-10-20 at 10:56 -0700, Thomas Pedersen wrote:
>
>> >> I'm not sure what you mean, this is the only way to get the WMM
>> >> parameters? Usually these are just set with ieee80211_set_wmm_defaul()
>> >> on bringing up the interface.
>> >
>> > Right, but
>> >  a) if you're using just the default, no need to derive from the default
>>
>> The user might wish to customize the queue parameters though.
>>
>> >  b) should they be changeable?
>>
>> Why not?
>
> Well there no API for it now, is there?
>

NL80211_ATTR_WIPHY_TXQ_PARAMS?
