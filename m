Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:63536 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbYCKQeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 12:34:16 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2492558wff.4
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 09:34:16 -0700 (PDT)
Message-ID: <c4aed99f0803110934h1d92eff3hbedd62df61160122@mail.gmail.com> (sfid-20080311_163419_597923_D429279F)
Date: Tue, 11 Mar 2008 12:34:16 -0400
From: "Chris Hallinan" <challinan@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Bug 1623
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240803102317q6173e243nd7dff52fe83089f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c4aed99f0803100702h10d54260g22512d9d6bb850d2@mail.gmail.com>
	 <1ba2fa240803100805o17d8239cm741891e5895dd07f@mail.gmail.com>
	 <c4aed99f0803101650n69aaaac0n540f5acbc6dd554c@mail.gmail.com>
	 <1ba2fa240803102317q6173e243nd7dff52fe83089f2@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2008 at 2:17 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, Mar 11, 2008 at 1:50 AM, Chris Hallinan <challinan@gmail.com> wrote:
>  > On Mon, Mar 10, 2008 at 11:05 AM, Tomas Winkler <tomasw@gmail.com> wrote:
>  >
>  > > On Mon, Mar 10, 2008 at 4:02 PM, Chris Hallinan <challinan@gmail.com> wrote:
>  >  >  > http://bughost.org/bugzilla/show_bug.cgi?id=1623
>  >  >  >
>  >  >  >  Anything else I can do to help move this along?  I'd love to dive into
>  >  >  >  the code, I just need a little guidance!  I've written and debugged a
>  >  >  >  few Linux drivers in my day...
>  >  >  >
>  >  >  >  Any other testing you need, I'd be happy to assist.
>  >  >  >
>  >  >  >  Thanks,
>  >  >  >
>  >  >  >  Chris
>  >  >
>  >  >  We've recently committed fixes to 4965 rate scaling can you try the
>  >  >  latest version of wireless-testing kernel?
>  >  >
>  >  I was unable to get either 1.2.25 nor top-of-tree from git (iwlwifi)
>  >  to compile with wireless-testing kernel.
>
>  I see, the point is that wireless-testing already contains latest
>  iwlwifi driver much newer then 1.2.25. so no need for patching just
>  compile the kernel.

OK, sorry for the confusion, iwl4965 was not enabled by default, and I
assumed it was not there.
I've completed the test, wireless-testing kernel from two days ago
does not resolve the slow wireless connection.  I will update the bug
report with this data.

>
>
>  >  As another data point, it appears the iwl4965 operates at full speed
>  >  using a more up-to-date Wireless Access Point such as the
>  >  Cisco/Linksys WAP4400N.
>
>  I'm not so familiar with the Linksys-B AP. Is it B-only AP?
>  I suspect there is a problem in rate scaling and we are going beyond
>  the CCK rates which B-only AP cannot hear.
>  but this is only shutting to darkness, need to reproduce.
>  I'm not sure if you have a sniffer but capture of traffic would be very useful.

It's an old Wireless-B unit, so I can only guess it's 'B' only.  It is
a Linksys WAP11 Ver. 2.0
Firmware: v2.05, Aug. 04, 2003.  Unfortunately, the hotels and coffee
shops around the country are filled with these units, and I travel for
a living, so I'm holding out hopes for a solution, and stand ready to
help in any way I can.

Again, I will update the bug report with this data.

Regards,

Chris
