Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:32818 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755047AbZCGTa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Mar 2009 14:30:29 -0500
Date: Sat, 7 Mar 2009 14:25:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: j@w1.fi, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mac80211_hwsim: add regulatory_hint support
Message-ID: <20090307192529.GB6648@tuxdriver.com> (sfid-20090307_203036_647099_CBED409E)
References: <1236316387-9718-1-git-send-email-lrodriguez@atheros.com> <1236316387-9718-2-git-send-email-lrodriguez@atheros.com> <43e72e890903061409h1cc9f1a2r501fd44a05b8c786@mail.gmail.com> <43e72e890903061905g6a2bff1bld0232e05409643b9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890903061905g6a2bff1bld0232e05409643b9@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 06, 2009 at 07:05:30PM -0800, Luis R. Rodriguez wrote:
> On Fri, Mar 6, 2009 at 2:09 PM, Luis R. Rodriguez
> <lrodriguez@atheros.com> wrote:
> > On Thu, Mar 5, 2009 at 9:13 PM, Luis R. Rodriguez
> > <lrodriguez@atheros.com> wrote:
> >> ACME Inc. only sells these in Finland.
> >
> > On second thought this is not such a good idea as simply loading it
> > would change your regulatory domain which is not the desired effect
> > for testing purposes. I will resend with some other things to avoid
> > undesired regulatory changes.
> 
> I see this was merged already - its ok, I'll just send a patch on top.

It is only in wireless-testing -- I can still drop the original
before sending to Dave.  So, it is probably best to just send a
replacement patch.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
