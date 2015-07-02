Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46521 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751524AbbGBLit (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2015 07:38:49 -0400
Message-ID: <1435837125.2285.7.camel@sipsolutions.net> (sfid-20150702_133852_283618_740392F1)
Subject: Re: AP + P2P_GO multichan tests with intel7260 as a P2P_CLIENT -
 direct probe issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	"Peer, Ilan" <ilan.peer@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Thu, 02 Jul 2015 13:38:45 +0200
In-Reply-To: <CABPxzYLVDUsFu3WwCFzYjE-sZtARiDSM6iGRu6RSFxeJ7k=rOw@mail.gmail.com> (sfid-20150702_110308_268288_A41D6D36)
References: <CALhHN=qr6k_a8W-8SGG4CNipB+Ovm3qxJnzKd0yL6JUYD4eT_Q@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF2DE@HASMSX110.ger.corp.intel.com>
	 <CABPxzYK1yvRuYnZP4xgywJy0wEx28MCZWw-G09kr7MNzZ6MMxA@mail.gmail.com>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DADF415@HASMSX110.ger.corp.intel.com>
	 <CABPxzYKPAf+bXdMoiY5DYz6HPMF=C0wQ0c4igJnTqmNAuk_yvA@mail.gmail.com>
	 <1435082418.2777.11.camel@ipeer-box>
	 <CB3B3D4774441E42AA3EA0E1BA8230A04DAE2088@HASMSX110.ger.corp.intel.com>
	 <CALhHN=okaQGRQAPdLm1dxCaYFDBD3bq4=yr2eMU_55LDtzoHLw@mail.gmail.com>
	 <1435822032.2285.2.camel@sipsolutions.net>
	 <CABPxzYLVDUsFu3WwCFzYjE-sZtARiDSM6iGRu6RSFxeJ7k=rOw@mail.gmail.com>
	 (sfid-20150702_110308_268288_A41D6D36)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-07-02 at 14:32 +0530, Krishna Chaitanya wrote:
> 
> We have also found another issue with direct probe.
> Some of the AP's are not setting sequence number in the probe 
> responses
> so in case of a retry they are dropped as duplicate by rx_h_check
> causing direct probe to fail.

I don't quite see how that can be an issue, since the RETRY bit
shouldn't be set??

johannes
