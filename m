Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:43506 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668AbXFPTNi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jun 2007 15:13:38 -0400
Received: by py-out-1112.google.com with SMTP id a29so2243212pyi
        for <linux-wireless@vger.kernel.org>; Sat, 16 Jun 2007 12:13:37 -0700 (PDT)
Date: Sat, 16 Jun 2007 15:13:34 -0400
From: "Andrew J. Barr" <andrew.james.barr@gmail.com>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: Re: Please pull latest and greatest bcm43xx
Message-ID: <20070616151334.03fcee13@powerbook.oakcourt.dyndns.org>
In-Reply-To: <200706162017.47516.mb@bu3sch.de>
References: <200706162017.47516.mb@bu3sch.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 16 Jun 2007 20:17:47 +0200
Michael Buesch <mb@bu3sch.de> wrote:

> John,
> 
> Please pull for-linville branch of my tree.
> It contains a lot of bugfixes and makes a _big_ step towards
> mergability for mainline.
> It's not 100% ready for a merge, yet, but we are making good progress.
> The transmission power problems on the 4306, that were one of the big
> merge blockers, seem almost all fixed. I get good performance now.
> I also added lots of txpower debugging stuff so one can actually
> see what's going on and how it's scaling.
> Together with Michael Wu's sta-locking rewrite patch for
> mac80211 we have the most critical merge blockers resolved now.
 
> I'd like people to test this code.
> It will spew a big assertion failure and a stacktrace on loading.
> Ignore that for now. It's known and considered nonfatal for now.

Hi,

I'd like to try this, but it does seem that for a number of things, the
2.6.18-4-powerpc kernel that ships with Etch is very stable and
bug-free on my Powerbook G4 17". Is there any hope of backporting just
the mac80211 and bcm43xx stuff to that kernel? The appletouch driver
and (oddly enough) some aspects of bcm43xx (e.g. connecting at long
distances) seem to work better on the Etch official kernel than on
upstream kernel.org sources or branches of that.

Regards,
Andrew Barr
