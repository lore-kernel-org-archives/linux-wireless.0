Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:43753 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbZKFWMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2009 17:12:37 -0500
Received: by fg-out-1718.google.com with SMTP id d23so438975fga.1
        for <linux-wireless@vger.kernel.org>; Fri, 06 Nov 2009 14:12:42 -0800 (PST)
Subject: RE: [ipw3945-devel] iwl3945 microcode errors
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "Cahill, Ben M" <ben.m.cahill@intel.com>
Cc: iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <02B3067C068D0549A8CCFCB17D4D318B4B095E52@orsmsx502.amr.corp.intel.com>
References: <1257208794.6556.2.camel@maxim-laptop>
	 <02B3067C068D0549A8CCFCB17D4D318B4B095E52@orsmsx502.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 Nov 2009 00:12:38 +0200
Message-ID: <1257545558.4048.4.camel@maxim-laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-11-02 at 18:07 -0800, Cahill, Ben M wrote: 
> Thanks for the report; disappointing news.
Oops. I reported a bug I introduced....
http://bugzilla.intellinuxwireless.org/show_bug.cgi?id=2113

I take a look at the issue.

Sorry.
Best regards,
Maxim Levitsky

> 
> Don't forget to load driver with debug=0x43fff, to get Error and Event logs.
> 
> -- Ben -- 
> 
> >-----Original Message-----
> >From: Maxim Levitsky [mailto:maximlevitsky@gmail.com] 
> >Sent: Monday, November 02, 2009 7:40 PM
> >To: iwlwifi maling list; linux-wireless
> >Subject: [ipw3945-devel] iwl3945 microcode errors
> >
> >I see that iwl3945 began to show some microcode errors like that:
> >
> >[   18.259947] iwl3945 0000:06:00.0: firmware: requesting 
> >iwlwifi-3945-2.ucode
> >[   18.766225] iwl3945 0000:06:00.0: loaded firmware version 15.32.2.9
> >[   18.817952] iwl3945 0000:06:00.0: Microcode SW error 
> >detected. Restarting 0x82000008.
> >[   18.817971] iwl3945 0000:06:00.0: Error Reply type 
> >0x00000000 cmd UNKNOWN (0x88) seq 0xDB3B ser 0x00880000
> >[   18.822468] iwl3945 0000:06:00.0: Can't stop Rx DMA.
> >[   20.790058] iwl3945 0000:06:00.0: Wait for START_ALIVE 
> >timeout after 2000ms.
> >
> >Now it still works, but there were cases it didn't.
> >
> >I post more detailed info soon.
> >
> >Best regards,
> >	Maxim Levitsky
> >
> >
> >---------------------------------------------------------------
> >---------------
> >Come build with us! The BlackBerry(R) Developer Conference in SF, CA
> >is the only developer event you need to attend this year. 
> >Jumpstart your
> >developing skills, take BlackBerry mobile applications to 
> >market and stay 
> >ahead of the curve. Join us from November 9 - 12, 2009. Register now!
> >http://p.sf.net/sfu/devconference
> >_______________________________________________
> >Ipw3945-devel mailing list
> >Ipw3945-devel@lists.sourceforge.net
> >https://lists.sourceforge.net/lists/listinfo/ipw3945-devel
> >


