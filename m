Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49718 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab0IRAUc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Sep 2010 20:20:32 -0400
Date: Fri, 17 Sep 2010 20:19:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing or wireless-next
Message-ID: <20100918001950.GA2178@tuxdriver.com>
References: <201009171148.39953.br1@einfach.org>
 <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 16, 2010 at 08:02:26PM -0700, Luis R. Rodriguez wrote:
> On Thu, Sep 16, 2010 at 7:48 PM, Bruno Randolf <br1@einfach.org> wrote:
> > John, Luis,
> >
> > I'm a little confused about which tree to use. I though we should base driver
> > development on wireless-testing, but I see that you merge patches into
> > wireless-next first. So should we re-base patches to wireless-next before we
> > send them?
> 
> Rule of thumb is if its large use linux-next, wireless-testing just
> lets you actually boot a usable kernel.

Actually, I generally prefer that patches target wireless-testing.
In the even of conflicts between that and wireless-next-2.6, I can
usually sort them out myself.  If not, I'll ask.

> > Also, AFAIK, compat-wireless is based on linux-next, so if I want to create a
> > compat-wireless package based on my latest driver changes (I need to do this
> > frequently for testing my driver on my platform), I always run into problems
> > because my latest driver is in wireless-testing and not in linux-next. Do you
> > have any advise on a proper workflow here?
> 
> I have a "wl" branch for wireless-testing too :)  the master branch is
> for linux-next.

Actually, there will almost never be anything in wireless-testing
that isn't in linux-next.  linux-next pulls from wireless-next-2.6,
just as wireless-testing does.

John
-- 
John W. Linville                Someday the world will need a hero, and you
linville@tuxdriver.com                  might be all we have.  Be ready.
