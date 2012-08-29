Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog135.obsmtp.com ([74.125.149.84]:40114 "EHLO
	na3sys009aog135.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab2H2S6J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 14:58:09 -0400
Received: by bkwj10 with SMTP id j10so463138bkw.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Aug 2012 11:58:07 -0700 (PDT)
Message-ID: <1346266668.3935.23.camel@cumari.coelho.fi> (sfid-20120829_205814_589618_3AA0F398)
Subject: Re: [PATCH 3.6-rc3] wlcore: Declare MODULE_FIRMWARE usage
From: Luciano Coelho <coelho@ti.com>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Eliad Peller <eliad@wizery.com>,
	Arik Nemtsov <arik@wizery.com>, Eyal Shapira <eyal@wizery.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Date: Wed, 29 Aug 2012 21:57:48 +0300
In-Reply-To: <503E4DBB.4030606@canonical.com>
References: <1346251689-37023-1-git-send-email-tim.gardner@canonical.com>
	 <1346259706.3935.2.camel@cumari.coelho.fi> <503E4DBB.4030606@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-08-29 at 11:13 -0600, Tim Gardner wrote:
> On 08/29/2012 11:01 AM, Luciano Coelho wrote:
> > On Wed, 2012-08-29 at 08:48 -0600, Tim Gardner wrote:
> >> Cc: Luciano Coelho <coelho@ti.com>
> >> Cc: "John W. Linville" <linville@tuxdriver.com>
> >> Cc: Eliad Peller <eliad@wizery.com>
> >> Cc: Arik Nemtsov <arik@wizery.com>
> >> Cc: Eyal Shapira <eyal@wizery.com>
> >> Cc: linux-wireless@vger.kernel.org
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
> >> ---
> > 
> > Please add a proper commit message.  And there's no need to put all
> > these people in Cc: in the commit log.  CC'ing when sending the patch is
> > enough (even though for such small patch, the linux-wireless mailing
> > list and myself is enough).
> > 
> > --
> > Luca.
> > 
> 
> What more would you like covered in the commit message that isn't
> obvious from the subject?

It's obvious from the subject, indeed.  But commits with no descriptions
are ugly.  Add something, for example a small "why" would be nice.


> The Cc list comes from scripts/get_maintainers.pl as suggested by
> Documentation/SubmittingPatches: "5) Select e-mail destination."

Yeah, that's correct, but it doesn't mean you should put them as Cc:
tags in the commit log.  CCing when *sending* the email only is enough.
Most people won't really care for the entire lifetime of this patch.
And, come on, the Cc tags take more space than the actual patch.

--
Luca.

