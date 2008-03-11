Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.181]:6343 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514AbYCKPb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2008 11:31:57 -0400
Received: by el-out-1112.google.com with SMTP id v27so1460481ele.17
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2008 08:31:56 -0700 (PDT)
Message-ID: <1ba2fa240803110831n4cf4f596lde184a44904010e9@mail.gmail.com> (sfid-20080311_153201_759006_91B68BC3)
Date: Tue, 11 Mar 2008 17:31:55 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Chris Hallinan" <challinan@gmail.com>
Subject: Re: Bug 1623
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47D6A1B4.8060603@yahoo.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
References: <c4aed99f0803100702h10d54260g22512d9d6bb850d2@mail.gmail.com>
	 <1ba2fa240803100805o17d8239cm741891e5895dd07f@mail.gmail.com>
	 <c4aed99f0803101650n69aaaac0n540f5acbc6dd554c@mail.gmail.com>
	 <1ba2fa240803102317q6173e243nd7dff52fe83089f2@mail.gmail.com>
	 <43e72e890803110803k5dae7300i94ff883c4dd5e9e9@mail.gmail.com>
	 <47D6A1B4.8060603@yahoo.it>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2008 at 5:13 PM, Filippo Zangheri
<filippo.zangheri@yahoo.it> wrote:
> Luis R. Rodriguez ha scritto:
>
>
> > On Tue, Mar 11, 2008 at 2:17 AM, Tomas Winkler <tomasw@gmail.com> w=
rote:
>  >> On Tue, Mar 11, 2008 at 1:50 AM, Chris Hallinan <challinan@gmail.=
com> wrote:
>  >>  > On Mon, Mar 10, 2008 at 11:05 AM, Tomas Winkler <tomasw@gmail.=
com> wrote:
>  >>  >
>  >>  > > On Mon, Mar 10, 2008 at 4:02 PM, Chris Hallinan <challinan@g=
mail.com> wrote:
>  >>  >  >  > http://bughost.org/bugzilla/show_bug.cgi?id=3D1623
>  >>  >  >  >
>  >>  >  >  >  Anything else I can do to help move this along?  I'd lo=
ve to dive into
>  >>  >  >  >  the code, I just need a little guidance!  I've written =
and debugged a
>  >>  >  >  >  few Linux drivers in my day...
>  >>  >  >  >
>  >>  >  >  >  Any other testing you need, I'd be happy to assist.
>  >>  >  >  >
>  >>  >  >  >  Thanks,
>  >>  >  >  >
>  >>  >  >  >  Chris
>  >>  >  >
>  >>  >  >  We've recently committed fixes to 4965 rate scaling can yo=
u try the
>  >>  >  >  latest version of wireless-testing kernel?
>  >>  >  >
>  >>  >  I was unable to get either 1.2.25 nor top-of-tree from git (i=
wlwifi)
>  >>  >  to compile with wireless-testing kernel.
>  >>
>  >>  I see, the point is that wireless-testing already contains lates=
t
>  >>  iwlwifi driver much newer then 1.2.25. so no need for patching j=
ust
>  >>  compile the kernel.
>  >
>  > Or if you don't want to compile your kernel and just compile the
>  > modules externally you can grab the compat-wireless-package that p=
ulls
>  > daily from wireless-testing:
>  >
>  > http://linuxwireless.org/en/users/Download
>
>  I can confirm that. Building wireless drivers modules and subsystem
>  was never so easy and time-efficient.
>
>  Maybe this is useless, but if you want to avoid bulding all modules
>  and subsystems you just need to edit config.mk.
>
>  Great project!
>
>  Just my =800.02.
>
>  --
>  Filippo Zangheri
>
>  GPG key ID: 0xE1D879FA
>  Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
>  Key server: pgp.mit.edu
>
>  -----BEGIN GEEK CODE BLOCK-----
>  Version: 3.12
>  GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
>  V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
>  r++ z*
>  ------END GEEK CODE BLOCK------
>
>

Chris
If you are able to get running wireless-testing can you just dump
debugfs rate_scale_table file.  Since it's run time data it has to be
done while preforming the test.

The file is usually located under
/sys/kernel/debug/ieee80211/phy0/stations/<AP mac
address>/rate_scale_table

Thanks
Tomas

>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wire=
less" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
