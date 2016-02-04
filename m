Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f170.google.com ([209.85.161.170]:34787 "EHLO
	mail-yw0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966AbcBDMnn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2016 07:43:43 -0500
Received: by mail-yw0-f170.google.com with SMTP id h129so25922480ywb.1
        for <linux-wireless@vger.kernel.org>; Thu, 04 Feb 2016 04:43:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1454589301.2564.8.camel@sipsolutions.net>
References: <CABPxzY+HpP=NTrAaUEzV5nFm=LK93m=kxPV14-cdftt+VPsWNw@mail.gmail.com>
 <CA+BoTQ=s_SMgs9zkgYjKOHKDwRORWk-Re7XZ=AiKiHCuNc0L8A@mail.gmail.com>
 <1454588396.2564.7.camel@sipsolutions.net> <CABPxzYL3mGHyoKE0tkL4yg_4NL+U41+15Bm3f=JPq2vfD+Xnkg@mail.gmail.com>
 <1454589301.2564.8.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Thu, 4 Feb 2016 18:13:23 +0530
Message-ID: <CABPxzY+N=3cuMB4Z7q6gqPkhh1GoiCrpG6G3E2bHLB96oqZfyw@mail.gmail.com> (sfid-20160204_134351_606413_663C9D2F)
Subject: Re: mac80211_hwsim + iperf + netns
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 4, 2016 at 6:05 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2016-02-04 at 17:58 +0530, Krishna Chaitanya wrote:
>> On Thu, Feb 4, 2016 at 5:49 PM, Johannes Berg <johannes@sipsolutions.
>> net> wrote:
>> > On Thu, 2016-02-04 at 12:32 +0100, Michal Kazior wrote:
>> > >
>> > >  ip netns add ns1
>> > >  ip netns exec ns1 bash # get the PID in the session and don't
>> > > close
>> > > it
>> > >  iw phy phyX set netns $pid_of_that_shell
>> > >
>> >
>> > If you also have a recent enough iw version, you can use
>> >
>> > iw phy phyX set netns name ns1
>> >
>> My iw has this option, but it throws an error.
>> Does this command have any prerequisites?
>>
>> # iw phy phy1 set netns name ns1
>> Invalid parameter: nsname(name)
>>
>
> This happens if the ns1 doesn't exist.
ok, so we need latest iprotue2 to create the
namespace?
