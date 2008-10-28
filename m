Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f18.google.com ([209.85.217.18]:40547 "EHLO
	mail-gx0-f18.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329AbYJ1QMM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 12:12:12 -0400
Message-ID: <1ba2fa240810280912pea7284ejd6de5d04efbb974f@mail.gmail.com> (sfid-20081028_171218_874314_62F8D4BA)
Date: Tue, 28 Oct 2008 18:12:09 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Soeren Sonnenburg" <kernel@nn7.de>, linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200810281630.28389.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810272350.29429.rjw@sisk.pl>
	 <1ba2fa240810271612g72bb2b08p6ebab9f6f02f5b98@mail.gmail.com>
	 <200810281630.28389.rjw@sisk.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2008 at 5:30 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Tuesday, 28 of October 2008, Tomas Winkler wrote:
>> h
>>
>> On Tue, Oct 28, 2008 at 12:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > On Monday, 27 of October 2008, Tomas Winkler wrote:
>> >> On Tue, Oct 28, 2008 at 12:28 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
>> >> > On Mon 27.Oct'08 at 23:07:00 +0200, Tomas Winkler wrote:
>> >> >>[...]
>> >> >>
>> >> >> Can someone try this one (it might be space broken I've just pasted
>> >> >> that in) It's on top of 1d63e726408dfdb3e10ed8f00c383b30ebb333d3
>> >> >> (latest linux-2.6.git)
>> >> >
>> >> >
>> >> > Yes, this one also works for me (I applied it manually).
>> >> Good, this was actually part of some older and bigger patch I wasn't
>> >> aware it has this affect. It has some millage in iwl5000 branch.
>> >> RFKIll went through some changes in the mainline so it wasn't merged yet.
>> >
>> > Are you going to push this patch upstream now?  It's quite important to get
>> > this resume regression fixed ASAP.
>>
>> Definitely I would post it to wireless and stable.
>
> Please send a CC to me too.
Hmm. It looks like I've misspelled your email when I've sent the patch.
Will send it again
Tomas
