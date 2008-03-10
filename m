Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:46166 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbYCJQYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Mar 2008 12:24:17 -0400
Received: by rn-out-0910.google.com with SMTP id v46so1335985rnb.15
        for <linux-wireless@vger.kernel.org>; Mon, 10 Mar 2008 09:24:16 -0700 (PDT)
Message-ID: <c4aed99f0803100924r43c1925fh222919e40b41c266@mail.gmail.com> (sfid-20080310_162423_078898_712F3F95)
Date: Mon, 10 Mar 2008 12:24:15 -0400
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
>

Not sure if I understand the terminology correctly (wireless-testing
kernel?) but I just tried the top-of-tree from git repo (iwlwifi) and
the results are the same.  Stuck at very low speed, and no apparent
activity on the rs_window /sys file.

Regards,

Chris
