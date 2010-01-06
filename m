Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:38546 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab0AFD5H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 22:57:07 -0500
Subject: RE: [ipw3945-devel] Panic in iwl3945 driver
From: Zhu Yi <yi.zhu@intel.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B5D15133F@orsmsx502.amr.corp.intel.com>
References: <1259167780.4072.2.camel@maxim-laptop>
	 <1259280022.3991.12.camel@maxim-laptop>
	 <1259596551.4090.0.camel@maxim-laptop>	<1259617333.4653.91.camel@rc-desk>
	 <1259620526.6559.34.camel@maxim-laptop>	<1259659724.12157.110.camel@debian>
	 <1259732550.12157.130.camel@debian>	<1259774227.26287.2.camel@maxim-laptop>
	 <1261413654.3556.6.camel@maxim-laptop>	<1261472251.12157.829.camel@debian>
	 <1262710566.3272.3.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B5D15133C@orsmsx502.amr.corp.intel.com>
	 <02B3067C068D0549A8CCFCB17D4D318B5D15133F@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jan 2010 11:57:05 +0800
Message-ID: <1262750225.15653.113.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-01-06 at 06:26 +0800, Cahill, Ben M wrote:
> >><3>[  330.762510] iwl3945 0000:06:00.0: 1035963222
> >>0x04dc0018     0401
> >
> >Last good command 0x18, with (driver provided) header
> >indicating sent via queue 4, queue index 0xdc
> >
> >><3>[  330.762547] iwl3945 0000:06:00.0: 1035963229
> >>0x00000000     0401
> >
> >This shows command "0" (non-existant/unsupported/bad command)
> >with (driver provided) header indicating sent via queue "0",
> >index "0"; obviously bad data in command queue.
> 
> Or index ("pointer") is getting out of sync.  (Reminder to self; never
> use the word "obviously"). 

Ben, does it smell like driver issue or firmware bug?

Thanks,
-yi

