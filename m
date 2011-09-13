Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:5930 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933105Ab1IMXn4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 19:43:56 -0400
Subject: RE: Bug#641424: iwlagn: fails to reconnect to WPA2-enterprise
 (Reason: 23)
From: wwguy <wey-yi.w.guy@intel.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>,
	Miguel Martinez <el.quark@gmail.com>,
	"641424@bugs.debian.org" <641424@bugs.debian.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1315957298.14749.29.camel@deadeye>
References: <20110913111546.6947.55565.reportbug@mark>
	 <1315952954.14749.18.camel@deadeye>
	 <C5A7FB31FD9AEA42B600BDC3C74F8E00147CA83E@orsmsx511.amr.corp.intel.com>
	 <1315957298.14749.29.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Sep 2011 16:38:41 -0700
Message-ID: <1315957121.2336.0.camel@wwguy-ubuntu> (sfid-20110914_014359_357434_B3F5F7D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-09-13 at 16:41 -0700, Ben Hutchings wrote:
> On Tue, 2011-09-13 at 16:33 -0700, Venkataraman, Meenakshi wrote:
> > Hi Miguel,
> > 
> > It looks like the AP you're connected to at the University is a Cisco
> > AP. I'm not sure what reason code 23 is, will need to research it
> > some.
> 
> 	WLAN_REASON_IEEE8021X_FAILED = 23,
> 
> > In the meantime, can you do the following so we can see what's going
> > on in the iwlwifi driver:
> > 
> > 1) Enable debugging for the iwlwifi driver like so: 
> > 	modprobe iwlagn debug=0x47fff 
> > You'll need to enable debugging for iwlwifi while building the kernel.
> > 
> > 2) A wireless sniffer log would also be useful (not sure you're in a
> > position to gather this log).
> > 
> > Please send me (only) the log. We can take this to bugzilla as well.
> [...]
> 
> If you mean bugzilla.kernel.org, that is currently down along with much
> of the kernel.org infrastructure.
> 

please use http://bugzilla.intellinuxwireless.org

Thanks
Wey
> 


