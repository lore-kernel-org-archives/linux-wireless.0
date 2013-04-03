Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35446 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758541Ab3DCMsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 08:48:54 -0400
Message-ID: <1364993329.8351.37.camel@jlt4.sipsolutions.net> (sfid-20130403_144857_567435_EA97E9CC)
Subject: Re: problems with iwlwifi - intel 5300 - 5GHz - all versions
From: Johannes Berg <johannes@sipsolutions.net>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com
Date: Wed, 03 Apr 2013 14:48:49 +0200
In-Reply-To: <alpine.DEB.2.00.1304011908390.23668@uplift.swm.pp.se> (sfid-20130401_191237_181984_A9EDAC20)
References: <alpine.DEB.2.00.1303291240580.11255@uplift.swm.pp.se>
	 <alpine.DEB.2.00.1304011908390.23668@uplift.swm.pp.se>
	 (sfid-20130401_191237_181984_A9EDAC20)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-04-01 at 19:12 +0200, Mikael Abrahamsson wrote:
> On Fri, 29 Mar 2013, Mikael Abrahamsson wrote:
> 
> Another data point.
> 
> With 3.2.0-39 with backported 3.6 drivers 
> (linux-backports-modules-cw-3.6-3.2.0-39-generic-pae).

I really have no idea what your distro (Ubuntu?) backports into
everything, sorry.

If you can't connect, this might be related:
http://git.kernel.org/cgit/linux/kernel/git/iwlwifi/iwlwifi-fixes.git/commit/?id=b8730b403aee94db4631bfefb546a6ce8c287dc2

johannes


