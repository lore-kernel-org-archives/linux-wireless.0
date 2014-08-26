Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:47492 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751482AbaHZQuE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Aug 2014 12:50:04 -0400
Message-ID: <1409071794.585.16.camel@dubbel> (sfid-20140826_185019_041801_8D3BFA98)
From: Luca Coelho <luca@coelho.fi>
To: Jim Rees <rees@umich.edu>, egrumbach@gmail.com
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Date: Tue, 26 Aug 2014 19:49:54 +0300
In-Reply-To: <20140826114123.GA2737@umich.edu>
References: <20140826020721.GA1490@umich.edu>
	 <1409032360.32368.2.camel@dubbel> <20140826114123.GA2737@umich.edu>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: iwlwifi 35% loss rate after v3.16-rc5
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-08-26 at 07:41 -0400, Jim Rees wrote:
> Luca Coelho wrote:
> 
>   This is probably the commit that is to blame:
>   
>   43d826c iwlwifi: dvm: don't enable CTS to self
>   
>   Could you try again without just that one? If it's confirmed we can
>   revert that patch.
> 
> Yes, reverting that one commit fixes it.

Emmanuel, do you think we should revert this patch? Do you remember
exactly what we tried to address with it?

  
>   Also, any chance you can get sniffer logs of the problem?
> 
> I would be happy to if you can give me a hint how to do it. Do you just mean
> a pcap, or something else?

Jim, I meant an air capture with something like Wireshark.  You need to
have another WiFi NIC that supports monitor mode, though (like Intel's
7260 or any ath9k-based NIC).

--
Cheers,
Luca.

