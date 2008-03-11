Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:43991 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706AbYCKPD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 11:03:56 -0400
Received: by py-out-1112.google.com with SMTP id u52so3635886pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 08:03:55 -0700 (PDT)
Message-ID: <43e72e890803110803k5dae7300i94ff883c4dd5e9e9@mail.gmail.com> (sfid-20080311_150359_952088_A4787C38)
Date: Tue, 11 Mar 2008 11:03:52 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: Bug 1623
Cc: "Chris Hallinan" <challinan@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240803102317q6173e243nd7dff52fe83089f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

Or if you don't want to compile your kernel and just compile the
modules externally you can grab the compat-wireless-package that pulls
daily from wireless-testing:

http://linuxwireless.org/en/users/Download

  Luis
