Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vena.lwn.net ([206.168.112.25]:48427 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932AbZFWTGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2009 15:06:03 -0400
Date: Tue, 23 Jun 2009 13:06:02 -0600
From: Jake Edge <jake@lwn.net>
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	torvalds@linux-foundation.org, Pavel Machek <pavel@ucw.cz>,
	Greg KH <greg@kroah.com>, "corbet\@lwn.net" <corbet@lwn.net>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"akpm\@linux-foundation.org" <akpm@linux-foundation.org>,
	"alan\@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"tshibata\@ab.jp.nec.com" <tshibata@ab.jp.nec.com>
Subject: Re: [PATCH v3.1415] Documentation: add documentation summary for
 rc-series and merge window
Message-ID: <20090623130602.6cd6b713@chukar>
In-Reply-To: <m3bpoen5pp.fsf@intrepid.localdomain>
References: <20090622222217.GH23972@bombadil.infradead.org>
	<m3fxdqj2bz.fsf@lwn.net>
	<m3bpoen5pp.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 23 Jun 2009 20:52:02 +0200 Krzysztof Halasa wrote:

> Perhaps it's just me :-) but I think we're trying to codify the rules
> way too much. The general rules (merge window = new features etc) are
> obviously ok but why do we need strict details like intrusive vs
> non-intrusive etc? People should just use a common sense and good
> judgement and, if in doubt in some particular case, ask. We are unable
> to describe all situations in a single text file.

Me2 :)

That may be a flaw in some parts of this doc is that it tries to
get too detailed, too rigid, etc. for a process that is more fluid and
has lots of independent parts each working in its own slightly
different way.  It does seem like there is value in much of what's
here, but there just aren't any black-and-white rules for exactly how
patches are handled.

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
