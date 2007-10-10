Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3515 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753710AbXJJPiv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2007 11:38:51 -0400
Date: Wed, 10 Oct 2007 11:17:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dan Williams <dcbw@redhat.com>
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>
Subject: Re: mac80211/iwlwifi + hidden ssids
Message-ID: <20071010151713.GE5962@tuxdriver.com> (sfid-20071010_163856_146843_EEA685D0)
References: <470C9F28.1070803@gmail.com> <20071010130653.GB5962@tuxdriver.com> <1192026847.9739.4.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1192026847.9739.4.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 10, 2007 at 10:34:07AM -0400, Dan Williams wrote:

> best we can do is set AP_SCAN=2, let wpa_supplicant blow all the
> settings to the card, and just _hope_ that the card/driver are smart
> enough to find the hidden SSID on their own and associate.  Which is
> less often than we'd hope.

Dan, how does this comport w/ the mac80211 behavior?  I.E. if mac80211
can find my hidden AP when using WEP (or nothing), why can't ap_scan=2
find the same AP?

John
-- 
John W. Linville
linville@tuxdriver.com
