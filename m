Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7080 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830AbZKCCIW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 21:08:22 -0500
From: "Cahill, Ben M" <ben.m.cahill@intel.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Mon, 2 Nov 2009 18:07:53 -0800
Subject: RE: [ipw3945-devel] iwl3945 microcode errors
Message-ID: <02B3067C068D0549A8CCFCB17D4D318B4B095E52@orsmsx502.amr.corp.intel.com>
References: <1257208794.6556.2.camel@maxim-laptop>
In-Reply-To: <1257208794.6556.2.camel@maxim-laptop>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for the report; disappointing news.

Don't forget to load driver with debug=0x43fff, to get Error and Event logs.

-- Ben -- 

>-----Original Message-----
>From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
>Sent: Monday, November 02, 2009 7:40 PM
>To: iwlwifi maling list; linux-wireless
>Subject: [ipw3945-devel] iwl3945 microcode errors
>
>I see that iwl3945 began to show some microcode errors like that:
>
>[   18.259947] iwl3945 0000:06:00.0: firmware: requesting 
>iwlwifi-3945-2.ucode
>[   18.766225] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
>[   18.817952] iwl3945 0000:06:00.0: Microcode SW error 
>detected. Restarting 0x82000008.
>[   18.817971] iwl3945 0000:06:00.0: Error Reply type 
>0x00000000 cmd UNKNOWN (0x88) seq 0xDB3B ser 0x00880000
>[   18.822468] iwl3945 0000:06:00.0: Can't stop Rx DMA.
>[   20.790058] iwl3945 0000:06:00.0: Wait for START_ALIVE 
>timeout after 2000ms.
>
>Now it still works, but there were cases it didn't.
>
>I post more detailed info soon.
>
>Best regards,
>	Maxim Levitsky
>
>
>---------------------------------------------------------------
>---------------
>Come build with us! The BlackBerry(R) Developer Conference in SF, CA
>is the only developer event you need to attend this year. 
>Jumpstart your
>developing skills, take BlackBerry mobile applications to 
>market and stay 
>ahead of the curve. Join us from November 9 - 12, 2009. Register now!
>http://p.sf.net/sfu/devconference
>_______________________________________________
>Ipw3945-devel mailing list
>Ipw3945-devel@lists.sourceforge.net
>https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
>