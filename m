Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:13741 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbYIIAvk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Sep 2008 20:51:40 -0400
Received: by ug-out-1314.google.com with SMTP id k3so6719ugf.37
        for <linux-wireless@vger.kernel.org>; Mon, 08 Sep 2008 17:51:38 -0700 (PDT)
Message-ID: <1ba2fa240809081751n30eae41u16d8c505fd048da9@mail.gmail.com> (sfid-20080909_025145_905814_17AD549F)
Date: Tue, 9 Sep 2008 03:51:38 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Matthew Garrett" <mjg@redhat.com>
Subject: Re: [PATCH 4/4] mac80211: stop queues before carrier off
Cc: "Dan Williams" <dcbw@redhat.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080908233706.GA7465@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20080908153336.891710000@sipsolutions.net>
	 <20080908153510.167807000@sipsolutions.net>
	 <1ba2fa240809081440o2c88eaa7o1e120fe75c018b9e@mail.gmail.com>
	 <1220910240.9427.10.camel@localhost.localdomain>
	 <1ba2fa240809081508jd762ac6q9d8505879711d151@mail.gmail.com>
	 <20080908222859.GA6153@srcf.ucam.org>
	 <1ba2fa240809081632j6816f059s30cc3b4ea5dcc2ed@mail.gmail.com>
	 <20080908233706.GA7465@srcf.ucam.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 9, 2008 at 2:37 AM, Matthew Garrett <mjg@redhat.com> wrote:
> On Tue, Sep 09, 2008 at 02:32:35AM +0300, Tomas Winkler wrote:
>> On Tue, Sep 9, 2008 at 1:29 AM, Matthew Garrett <mjg@redhat.com> wrote:
>> > On Tue, Sep 09, 2008 at 01:08:17AM +0300, Tomas Winkler wrote:
>> >> It has to be other way around.
>> >
>> > [Citation needed]\
>>
>> This is how any other connection manager I know works. Maybe I'm
>> trapped in old concepts but I don't find current NM paradigm
>> friendly.
>
> It's the way it's been in NM since 2004, so I think changing it at this
> point would be unfriendly.

As I see it NM is evolving lately, which is good It didn't have
connection editor before.  Now they is just missing <connect> button
along add, edit and delete to  make me happy.

The aim isn't to build a Windows clone.

I didn't suggested this and wireless profile is a general concept
nothing to do with Windows.

Another example you live big building where everybody has an AP. So
your scan list has 50 entries.
Now you have to search by eye all this 50 entries instead of directly
requesting connection to your particular AP.
What I want to see is 3 APs my home, work and favorite coffee house. I
would access scan list only if I cannot find any of these three.

But we should probably move this conversation to different mailing
list.  Second I didn't plan to criticize anyone  I didn't do anything
actively to change it.  I just got little frustrated when testing
switching between APs

Thanks
Tomas
