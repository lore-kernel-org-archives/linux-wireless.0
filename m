Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.27]:53606 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbZJOF5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 01:57:23 -0400
Received: by qw-out-2122.google.com with SMTP id 9so177429qwb.37
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2009 22:56:16 -0700 (PDT)
From: Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: Stable compat-wireless 2.6.32-rc4 released
Date: Thu, 15 Oct 2009 11:26:04 +0530
Cc: tim.gardner@canonical.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <43e72e890910131542k376a87c5rc30feb6491a06867@mail.gmail.com> <200910141131.47500.kunal.gangakhedkar@gmail.com> <43e72e890910140734j196a06f2y8905d3eb1ba1abc8@mail.gmail.com>
In-Reply-To: <43e72e890910140734j196a06f2y8905d3eb1ba1abc8@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <200910151126.04423.kunal.gangakhedkar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 14 Oct 2009 8:04:32 pm Luis R. Rodriguez wrote:
> On Tue, Oct 13, 2009 at 11:01 PM, Kunal Gangakhedkar
>
> <kunal.gangakhedkar@gmail.com> wrote:
> > On Wednesday 14 Oct 2009 6:20:33 am Luis R. Rodriguez wrote:
> >> On Tue, Oct 13, 2009 at 5:25 PM, Tim Gardner <tim.gardner@canonical.com>
> >
> > wrote:
> >> > Speaking as a distro, what advantage does the stable wireless backport
> >> > offer for the currently released kernel if we are already consumers of
> >> > stable updates?
> >>
> >> Well if you are a distro stuck on the 2.6.31 kernel the stable
> >> compat-wireless-2.6.32 gets you 2.6.32 wireless bits on 2.6.31 and
> >> that means any features/drivers/large fixes/enhancements that didn't
> >> make it to 2.6.31.
> >
> > Isn't this the whole purpose of linux-backports-modules in ubuntu as
> > well?
>
> Yes, but lbm currently relies on the bleeding edge compat-wireless
> which is exactly that -- bleeding edge, it may or may not work. The
> stable compat-wireless releases are based on the latest stable kernel
> releases and latest rc kernel release so they are deemed to be stable
> snapshots following the kernel release cycle.
>
>   Luis

Got that - thanks for the explanation :)

Kunal
