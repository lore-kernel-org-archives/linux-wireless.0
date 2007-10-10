Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3623 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755923AbXJJUij (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 16:38:39 -0400
Date: Wed, 10 Oct 2007 16:24:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	linux-wireless@vger.kernel.org
Cc: Dana R <dana.r.ferguson@intel.com>, Dan Williams <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: [PATCH 2.6.23.RC9] wpa_supplicant didn't work w/ wpa_secured
	hidden AP
Message-ID: <20071010202422.GN5962@tuxdriver.com> (sfid-20071010_213845_637104_A2C288DF)
References: <1192040814.12399.4.camel@abhi-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192040814.12399.4.camel@abhi-desktop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 11:26:54AM -0700, Abhijeet Kolekar wrote:
> This patch fixes the problem of associating with wpa_secured hidden
> ap.Please try out.
> 
> The original author of this patch is Bill Moss<bmoss@clemson.edu>
> 
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Wow...that is one busted patch...  Please avoid using editors that
convert tabs to whitespace.  Probably also need to account for existing
IEEE80211_SCAN_MATCH_SSID behavior...?

Still, the general idea looks fine and I'd really like to make
wpa_supplicant and mac80211 work together with hidden APs.  I'll fix-up
the patch and post it as a follow-up to this message...

John

P.S.  Is limiting this to STA mode correct?  Would wpa_supplicant
ever set that flag for an IBSS?
-- 
John W. Linville
linville@tuxdriver.com
