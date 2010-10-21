Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:11627 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab0JUQ7a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Oct 2010 12:59:30 -0400
Subject: Re: Modifying the driver iwlwifi
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Cassiano Tartari, Eng." <falecom@cassianotartari.eng.br>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
References: <AANLkTinP32=snam3Bex+OC8LL00awfjrJz4834mhOaNL@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 21 Oct 2010 09:58:35 -0700
Message-Id: <1287680315.4759.4.camel@wwguy-ubuntu>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Cassiano,

On Thu, 2010-10-21 at 09:17 -0700, Cassiano Tartari, Eng. wrote:
> Hi,
> 
>   I'm a masters student of Automation and Systems Engineering at
> Federal University of Santa Catarina in Brazil. I'd like to know if it
> is possible to modify the implementation of iwlwifi because I need to
> decrease the time of association between the client and the AP. I'd
> like to implement something in the same way like I read in an article,
> project QuickWifi. Its basic idea is that a client doesn't wait each
> response to go to the next step, so just do: AUTH REQ -> ASSOC REQ ->
> DHCP DISC -> DHCP REQ -> ARP QUERY and a PING THROUGH to verify that
> an end-to-end connection is available.
> 
>     I need this to my work, it will be used for the communication
> between a moving vehicle and a fixed point on the street.
> 

It is an open source project, so please feel free to make the
modifications; but please do follow the upstream process and submit the
patch to either "internal-wifi-devel@linux.intel.com" mailing list or
"linux-wireless@vger.kernel.org" mailing list for review

Thanks
Wey

