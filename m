Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58855 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130Ab1JQOyU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:54:20 -0400
Subject: Re: 3.1.0-rc9+ : wlan stops working w/o any error messages
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: David Rientjes <rientjes@google.com>, werner <w.landgraf@ru.ru>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <201110170952.43916.toralf.foerster@gmx.de>
References: <201110152119.58509.toralf.foerster@gmx.de>
	 <alpine.DEB.2.00.1110151416360.15894@chino.kir.corp.google.com>
	 <201110170931.59534.toralf.foerster@gmx.de>
	 <201110170952.43916.toralf.foerster@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Oct 2011 07:04:06 -0700
Message-ID: <1318860246.31823.33.camel@wwguy-huron> (sfid-20111017_165438_257372_81C5070D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-10-17 at 00:52 -0700, Toralf Förster wrote:
> Toralf Förster wrote at 09:31:58
> > > What does "iwconfig" show?
> 
> And this is the state if the netwerk stops working :
> 
> wlan0     IEEE 802.11abgn  ESSID:"IBM"  
>           Mode:Managed  Frequency:2.462 GHz  Access Point: 00:21:55:AC:8B:80   
>           Bit Rate=54 Mb/s   Tx-Power=15 dBm   
>           Retry  long limit:7   RTS thr:off   Fragment thr:off
>           Encryption key:off
>           Power Management:off
>           Link Quality=45/70  Signal level=-65 dBm  
>           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
>           Tx excessive retries:0  Invalid misc:77   Missed beacon:0
> 
> 
when you say "stop working", but it is still associated, correct? just
no traffic get through.

Thanks
Wey

