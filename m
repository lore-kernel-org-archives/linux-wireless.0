Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:35179 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab0HRQxk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Aug 2010 12:53:40 -0400
From: "Berg, Johannes" <johannes.berg@intel.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Date: Wed, 18 Aug 2010 17:53:34 +0100
Subject: RE: [PATCH 2/2] iwlwifi: do not spuriously call
 ieee80211_scan_completed
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501CB7CD0C6@irsmsx504.ger.corp.intel.com>
References: <1282149322-17928-1-git-send-email-wey-yi.w.guy@intel.com>
 <1282149322-17928-3-git-send-email-wey-yi.w.guy@intel.com>
 <20100818164405.GA2793@tuxdriver.com>
In-Reply-To: <20100818164405.GA2793@tuxdriver.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > When a scan is aborted because the corresponding
> > virtual interface is removed, we may still later
> > attempt to tell mac80211 that the scan completed.
> > This is obviously wrong, since we already told it
> > that it was aborted, so don't do that.


> Does this really qualify as a fix for 2.6.36?  Is it a regression?
> Does it generate an oops?  Or loss of connectivity?

It only creates a spurious warning.

johannes
--------------------------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen, Deutschland 
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 
Ust.-IdNr./VAT Registration No.: DE129385895
Citibank Frankfurt a.M. (BLZ 502 109 00) 600119052

