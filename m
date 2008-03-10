Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.173]:5117 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYCJXuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 19:50:51 -0400
Received: by wf-out-1314.google.com with SMTP id 28so2127499wff.4
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2008 16:50:51 -0700 (PDT)
Message-ID: <c4aed99f0803101650n69aaaac0n540f5acbc6dd554c@mail.gmail.com> (sfid-20080310_235056_343945_A25616FD)
Date: Mon, 10 Mar 2008 19:50:50 -0400
From: "Chris Hallinan" <challinan@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Bug 1623
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240803100805o17d8239cm741891e5895dd07f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <c4aed99f0803100702h10d54260g22512d9d6bb850d2@mail.gmail.com>
	 <1ba2fa240803100805o17d8239cm741891e5895dd07f@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 10, 2008 at 11:05 AM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Mon, Mar 10, 2008 at 4:02 PM, Chris Hallinan <challinan@gmail.com> wrote:
>  > http://bughost.org/bugzilla/show_bug.cgi?id=1623
>  >
>  >  Anything else I can do to help move this along?  I'd love to dive into
>  >  the code, I just need a little guidance!  I've written and debugged a
>  >  few Linux drivers in my day...
>  >
>  >  Any other testing you need, I'd be happy to assist.
>  >
>  >  Thanks,
>  >
>  >  Chris
>
>  We've recently committed fixes to 4965 rate scaling can you try the
>  latest version of wireless-testing kernel?
>
I was unable to get either 1.2.25 nor top-of-tree from git (iwlwifi)
to compile with wireless-testing kernel.

As another data point, it appears the iwl4965 operates at full speed
using a more up-to-date Wireless Access Point such as the
Cisco/Linksys WAP4400N.

Given that input, is there somewhere else we could look?  I will
update the bug record with these findings.

-Chris
