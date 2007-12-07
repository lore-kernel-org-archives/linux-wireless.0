Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.232]:32081 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbXLGTQE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2007 14:16:04 -0500
Received: by nz-out-0506.google.com with SMTP id s18so563095nze
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2007 11:16:02 -0800 (PST)
Message-ID: <43e72e890712071116x7ede7c32y259056bc86ac3c24@mail.gmail.com> (sfid-20071207_191610_479842_E6C4EB82)
Date: Fri, 7 Dec 2007 14:16:01 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Automated kerneldoc for all wireless drivers
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1197031683.4171.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <43e72e890712061538k10d806f8xbb7148b0de3f66ce@mail.gmail.com>
	 <1197031683.4171.3.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Dec 7, 2007 7:48 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> On Thu, 2007-12-06 at 18:38 -0500, Luis R. Rodriguez wrote:
> > We now have automated kerneldoc HTML output for all Linux wireless
> > drivers. We just need to the references to our wiki added, and that's
> > it.
>
>
> I have disabled it for now, your script output is really cluttering the
> ~wireless homedir. Not nice.

The current kerneldoc() doesn't accept directories so I worked with
what I had. Notice though that the current kerneldoc scripts does put
the kerneldoc files into ~wireless/kdoc-drivers/ and in there you have
directories for drivers that have their own directory otherwise they
just have their kdoc there.

Perhaps some small and smart changes (which will prevent ../../../
usage and the like) can allow for it to read certain dirs.

> Instead of putting the <<kerneldoc>> macro on dozens of pages we should
> also just provide a virtual moin hierarchy like maybe
> linuxwireless.org/kerneldoc/<filename>.html or whatever to show it on
> the wiki and then we can refer to those pages easily.

ACK

that would be nice.

  Luis
