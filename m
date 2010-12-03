Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50682 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab0LCPAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 10:00:11 -0500
Date: Fri, 3 Dec 2010 09:56:55 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
	me@bobcopeland.com, jirislaby@gmail.com, nbd@openwrt.org,
	br1@einfach.org, sedat.dilek@googlemail.com
Subject: Re: [PATCH 5/6] ath5k: Update version string
Message-ID: <20101203145654.GB2348@tuxdriver.com>
References: <20101203041109.GE2988@makis.mantri>
 <AANLkTi=n0wkMTWxJvvNHHMyjvGA25JSr8awWKMJsAv+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <AANLkTi=n0wkMTWxJvvNHHMyjvGA25JSr8awWKMJsAv+g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 02, 2010 at 08:17:41PM -0800, Luis R. Rodriguez wrote:
> On Thu, Dec 2, 2010 at 8:11 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> >  * Change version number, we've added various new features lately.
> >  We need to find a way to maintain this, maybe on each kernel release
> >  or something. Also remove "EXPERIMENTAL", we aren't experimental any
> >  more I think ;-)
> >
> >  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
> 
> > +MODULE_VERSION("0.7.0");
> 
> How about just remove this all together, the version should go by the
> kernel or git describe.

ACK -- any objections?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
