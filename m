Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:54668 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147AbaBYP2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Feb 2014 10:28:20 -0500
Message-ID: <1393342096.4170.17.camel@jlt4.sipsolutions.net> (sfid-20140225_162822_441274_CC646CDB)
Subject: Re: [PATCH] cfg80211: regulatory, introduce NL80211_RRF_AUTO_BW
 rule flag
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Date: Tue, 25 Feb 2014 16:28:16 +0100
In-Reply-To: <CAB=NE6XgdG1==4KUpRYsqethg08Qvm_TPksq_9SG-mkwyKn2HQ@mail.gmail.com> (sfid-20140222_011922_942034_8D2D6CA2)
References: <1392900736-2808-1-git-send-email-janusz.dziedzic@tieto.com>
	 <CALhHN=oXr+PpiGv47sVzoi2cW_PYDME63sZ7euwtDaoVwnarTA@mail.gmail.com>
	 <1392971299.4346.20.camel@jlt4.sipsolutions.net>
	 <CAB=NE6XgdG1==4KUpRYsqethg08Qvm_TPksq_9SG-mkwyKn2HQ@mail.gmail.com>
	 (sfid-20140222_011922_942034_8D2D6CA2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-02-21 at 16:19 -0800, Luis R. Rodriguez wrote:
> On Fri, Feb 21, 2014 at 12:28 AM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > However, Luis, please sort out this situation, and if bits 9/10 were
> > ever used by userspace (they were never used by the kernel!) then please
> > submit a kernel patch that marks them as reserved in nl80211.h. The
> > kernel header file should be the master file defining the API, not some
> > "random" userspace tool.
> 
> Pretty sure NO-HT40 was never used (claimed bit 10), and not sure why
> bit bit 9 says reserved, I'm pretty sure it never got used too.

Ok, thanks.

johannes

