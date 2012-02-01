Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:37747 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753147Ab2BAPxM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 10:53:12 -0500
Subject: Re: iwlagn is getting even worse with 3.3-rc1
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	Norbert Preining <preining@logic.at>,
	linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
In-Reply-To: <20120201154335.GA8494@redhat.com>
References: <20120124013625.GB18436@gamma.logic.tuwien.ac.at>
	 <CANUX_P3er0orBy8OhDuY1DfgD810UD-_HB_ukJnCA+W8e-VazQ@mail.gmail.com>
	 <20120125002250.GA20431@gamma.logic.tuwien.ac.at>
	 <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com>
	 <20120126003735.GA2346@gamma.logic.tuwien.ac.at>
	 <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com>
	 <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com>
	 <20120126232555.GB16330@gamma.logic.tuwien.ac.at>
	 <CANUX_P0z2800ip=yfW15zELqhDNFrHbTvDY3OF59PuxizN=XSA@mail.gmail.com>
	 <20120131024143.GA10418@redhat.com>  <20120201154335.GA8494@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Feb 2012 06:45:55 -0800
Message-ID: <1328107555.7290.13.camel@wwguy-huron> (sfid-20120201_165332_175131_18FAC520)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-02-01 at 10:43 -0500, Dave Jones wrote:
> On Mon, Jan 30, 2012 at 09:41:43PM -0500, Dave Jones wrote:
>  
>  >  > > Generally fine.
>  >  > >
>  >  > > Thanks, more reports later.
>  >  > 
>  >  > Dave ?
>  > 
>  > after running with it all evening, it seems to be working fine so far.
> 
> Two days later, it hasn't locked up at all, so this is definitly fixing my problem.
> 
> One thing though, dmesg is flooded with these..
> 
> [ 4384.849732] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
> [ 4434.332275] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
> [ 4475.309883] iwlwifi 0000:04:00.0: Tx aggregation enabled on ra = b8:c7:5d:0c:39:87 tid = 0
> 
> Can it be supressed if the ra hasn't changed ?

John has a patch to fix this :-)

Wey
> 


