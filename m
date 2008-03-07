Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qb-out-0506.google.com ([72.14.204.228]:29996 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759185AbYCGTkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2008 14:40:42 -0500
Received: by qb-out-0506.google.com with SMTP id e11so586970qbe.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2008 11:40:41 -0800 (PST)
Message-ID: <43e72e890803071140s1ad8571w8f2b06c6b9cb1c12@mail.gmail.com> (sfid-20080307_194047_383259_6AE505D9)
Date: Fri, 7 Mar 2008 14:40:36 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: 2.6.24, mac80211 and b/g switching
Cc: "Vladimir Koutny" <vlado@work.ksp.sk>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200803071916.28776.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <47D160E4.3040503@work.ksp.sk>
	 <1204909966.6387.31.camel@johannes.berg>
	 <47D17EDF.4010100@work.ksp.sk> <200803071916.28776.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 7, 2008 at 1:16 PM, Michael Buesch <mb@bu3sch.de> wrote:
>
> On Friday 07 March 2008 18:43:59 Vladimir Koutny wrote:
>  > Johannes Berg wrote:
>  > >> Is this a known issue? (I didn't manage to find anything in ml archives
>  > >> so far) Or any hints on how to solve this?
>  > >
>  > > You want to develop against a non-ancient kernel that has all the HW
>  > > mode foo removed.
>  >
>  > Well, the question is not what version I would like to develop for, but
>  > what version I have to :( Stable kernel releases should be those
>  > versions you want to base real products on, right?
>  >
>  > Do you think that taking mac80211 from wireless-2.6 (or -testing or
>  > whatever) would cause way too many conflicts when merged back to 2.6.24?
>  >   Or am I on my own to fix this somehow in 2.6.24?
>
>  OpenWRT ported a rather recent mac80211 back to 2.6.23. So it shouldn't be too hard.

If you want to work with the latest wireless subsystem on older
kernels you can also use compat-wireless-2.6 package. It supports
kernels >= 2.6.21. Only thing left to do on 2.6.21 is to test PCI and
add any needed backports there.

http://linuxwireless.org/en/users/Download

  Luis
