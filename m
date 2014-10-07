Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47483 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaJGMro (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 08:47:44 -0400
Message-ID: <1412686059.1825.17.camel@jlt4.sipsolutions.net> (sfid-20141007_144748_060358_6EFE963F)
Subject: Re: [PATCH v2] cfg80211: allow to configure dynamic PS timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Zdenek Kabelac <zkabelac@redhat.com>
Date: Tue, 07 Oct 2014 14:47:39 +0200
In-Reply-To: <CABPxzYJ2Qghy87XhfSCdY+vB3CiNn-HpH_8BP=LfafLc37yiZQ@mail.gmail.com> (sfid-20141007_143309_753792_8324CEC0)
References: <1412083114-8426-1-git-send-email-sgruszka@redhat.com>
	 <542AB859.5080008@broadcom.com> <542AB893.9090201@broadcom.com>
	 <20141001092710.GB2011@redhat.com>
	 <1412607640.3098.33.camel@jlt4.sipsolutions.net>
	 <20141007110356.GA2902@redhat.com>
	 <1412683538.1825.13.camel@jlt4.sipsolutions.net>
	 <CABPxzYJ2Qghy87XhfSCdY+vB3CiNn-HpH_8BP=LfafLc37yiZQ@mail.gmail.com>
	 (sfid-20141007_143309_753792_8324CEC0)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-10-07 at 18:02 +0530, Krishna Chaitanya wrote:

> iw/iwconfig tools are not only used by regular users but also used by
> developers/
> engineers. We use it heavily for all our wifi testing, and when
> debugging performance
> related issue having a configurable ps timeout is of value. We had to
> hack the kernel
> to change that value (did not had enough time to work on iw/iwconfig).
> 
> So IMHO we need to have this configurable either through iw/mac80211 debugfs.

I'm not arguing that it shouldn't be there - I'm arguing it's more a
debug thing than a real operation thing.

johannes

