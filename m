Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37891 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab0ITOos (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Sep 2010 10:44:48 -0400
Date: Mon, 20 Sep 2010 10:42:39 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Ben Greear <greearb@candelatech.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bruno Randolf <br1@einfach.org>, linux-wireless@vger.kernel.org
Subject: Re: wireless-testing or wireless-next
Message-ID: <20100920144238.GB2434@tuxdriver.com>
References: <201009171148.39953.br1@einfach.org>
 <AANLkTinYo5qgXvSnQSHpLbhhBq0VG7Kh-X3dGK8NhXcj@mail.gmail.com>
 <4C950A22.6050105@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4C950A22.6050105@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Sep 18, 2010 at 11:51:14AM -0700, Ben Greear wrote:
> On 09/16/2010 08:02 PM, Luis R. Rodriguez wrote:
> >On Thu, Sep 16, 2010 at 7:48 PM, Bruno Randolf<br1@einfach.org>  wrote:
> >>John, Luis,
> >>
> >>I'm a little confused about which tree to use. I though we should base driver
> >>development on wireless-testing, but I see that you merge patches into
> >>wireless-next first. So should we re-base patches to wireless-next before we
> >>send them?
> >
> >Rule of thumb is if its large use linux-next, wireless-testing just
> >lets you actually boot a usable kernel.
> 
> I saw what looked like a nice series of patches from you four days ago
> (power save, etc).  But, they have not been applied to wireless-testing.
> 
> Is there a tree that does contain these sorts of patches, or must
> we manually apply them to our own trees if we want to try them out?

You are just a bit unlucky in this case...

I actually did have them in wireless-testing...on my machine. :-(
I had a little merge/push hiccup that should be resolved now --
must have been in too much of a hurry for my day-off on Friday!

Sorry for the inconvenience!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
