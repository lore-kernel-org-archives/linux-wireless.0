Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754689AbYESXeD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 19:34:03 -0400
Subject: Re: [2.6 patch] strip: remove dead URL
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Adrian Bunk <bunk@kernel.org>, linux-wireless@vger.kernel.org
In-Reply-To: <20080519223646.GA19835@tuxdriver.com>
References: <20080519221006.GZ17716@cs181133002.pp.htv.fi>
	 <20080519223646.GA19835@tuxdriver.com>
Content-Type: text/plain; charset=utf8
Date: Mon, 19 May 2008 19:27:51 -0400
Message-Id: <1211239671.10827.20.camel@localhost.localdomain> (sfid-20080520_013408_156558_60846C34)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-05-19 at 18:36 -0400, John W. Linville wrote:
> On Tue, May 20, 2008 at 01:10:06AM +0300, Adrian Bunk wrote:
> > http://mosquitonet.Stanford.EDU/strip.html no longer exists.
> >=20
> > Since the MAINTAINERS entry is now completely empty it's also remov=
ed.
> >=20
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
>=20
> Any reason why we should not just remove the driver?

Subject to the 2-kernel-release removal notice requirement or outright?
It looks like it was more of a research project than anything that
shipped too, and likely didn't get used by more than a handful of
people.

According to wikipedia [1] there were ~8,000 users of Ricochet in Denve=
r
and San Diego as of early 2006, how many of them might actually be usin=
g
the STRIP driver we don't know.  Denver apparently just got shut down i=
n
late March [2].

Also, apparently if you bought your modem after 2000 [3] [4], it doesn'=
t
support the peer-to-peer stuff that STRIP uses.  Thus, it seems (?)
you're limited to using the 28.8kbps modems with the STRIP driver.
Modems registered after 2000 may work in peer-to-peer with STRIP in
close proximity though.

So we can probably count the # of users on one amputated hand.  Not sur=
e
if that qualifies for removal or what.  Deprecation at least?

Dan

[1] =EF=BB=BFhttp://en.wikipedia.org/wiki/Ricochet_%28internet_service%=
29
[2] http://margysmusingsindenvercolorado.blogspot.com/2008/03/no-more-w=
ireless-service.html
[3] http://www.enlightenment-engine.com/eeng/Ricochet/Experiences%20wit=
h%20Metricom.htm
[4] http://illtel.denver.co.us/~abelits/metricom/


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
