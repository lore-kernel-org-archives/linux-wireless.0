Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34874 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751965AbaFKUmK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 16:42:10 -0400
Date: Wed, 11 Jun 2014 22:42:07 +0200
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"wireless-regdb@lists.infradead.org"
	<wireless-regdb@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Subject: Re: [wireless-regdb] [ANN] wireless-regdb: master-2014-05-19
Message-ID: <20140611204207.GD6042@wotan.suse.de> (sfid-20140611_224215_845945_51525987)
References: <20140519185046.GH7650@tuxdriver.com> <CALhHN=pEo5H4AnWpOAhPs8LyK35wyhGJyvHTrh12nauQ-tOpDg@mail.gmail.com>
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

How about on CRDA? Can you check if I merged the wrong stuff as I already
pushed as well? This also currently breaks the parses are there is no
support for the auto stuff yet.

  Luis
