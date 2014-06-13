Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38578 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaFMTaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 15:30:12 -0400
Date: Fri, 13 Jun 2014 15:25:30 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-regdb] [ANN] wireless-regdb: master-2014-05-19
Message-ID: <20140613192530.GB8392@tuxdriver.com> (sfid-20140613_213016_822415_F5A73975)
References: <20140519185046.GH7650@tuxdriver.com>
 <CALhHN=pEo5H4AnWpOAhPs8LyK35wyhGJyvHTrh12nauQ-tOpDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <CALhHN=pEo5H4AnWpOAhPs8LyK35wyhGJyvHTrh12nauQ-tOpDg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 11, 2014 at 09:15:19PM +0200, Janusz Dziedzic wrote:
> On 19 May 2014 20:50, John W. Linville <linville@tuxdriver.com> wrote:
> > A new release of wireless-regdb (master-2014-05-19) is available at:
> >
> > http://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2014.05.19.tar.gz
> >
> > Here is the short log of the changes included since the 2013-11-27
> > release:
> >
> > Bjørn Mork (1):
> >       wireless-regdb: update NO's regulatory rules
> >
> > Janusz Dziedzic (3):
> >       wireless-regdb: allow max bandwidth to be AUTO calculated
> >       wireless-regdb: set AUTO bandwidth for world regulatory
> This two above should not be merged. That was first version of auto
> bandwidth calculation, we skip :)

OK -- obviously I got confused...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
