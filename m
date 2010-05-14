Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40728 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab0ENOz2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 10:55:28 -0400
From: "Berg, Johannes" <johannes.berg@intel.com>
To: Dan Carpenter <error27@gmail.com>, "Zhu, Yi" <yi.zhu@intel.com>
CC: "Chatre, Reinette" <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 14 May 2010 15:55:23 +0100
Subject: RE: [patch -next] iwlwifi: testing the wrong variable in
	iwl_add_bssid_station()
Message-ID: <C5C86A19469DAE48AAAD0E5F3716E44501A4B892C9@irsmsx504.ger.corp.intel.com>
References: <20100514145346.GG17487@bicker>
In-Reply-To: <20100514145346.GG17487@bicker>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> The intent here is to test that "sta_id_r" is a valid pointer.  We do
> this same test later on in the function.

Indeed, thanks.

> Btw iwl_add_bssid_station() is called from two places and "sta_id_r" is
> a valid pointer from both callers.

Which explains why I didn't see that, and probably means
that we don't need the test at all...

johannes

---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

