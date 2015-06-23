Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:37840 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753540AbbFWLb1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Jun 2015 07:31:27 -0400
Message-ID: <1435059083.4765.2.camel@embedded.rocks> (sfid-20150623_133130_675313_B738F86E)
Subject: Re: brcmfmac: Failed to create interface p2p-dev-p2p0: -28 (No
 space left on device)
From: =?ISO-8859-1?Q?J=F6rg?= Krause <joerg.krause@embedded.rocks>
To: Arend van Spriel <aspriel@gmail.com>,
	Arend van Spriel <arend@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	brcm80211-dev-list <brcm80211-dev-list@broadcom.com>
Date: Tue, 23 Jun 2015 13:31:23 +0200
In-Reply-To: <55872A3C.7030704@gmail.com>
References: <1433766944.28058.16.camel@embedded.rocks>
						 <55758D7E.3000603@broadcom.com>
				 <1433771289.28058.24.camel@embedded.rocks>
				 <5575C6FA.6030104@broadcom.com>
				 <1433794640.28058.26.camel@embedded.rocks>
		 <557605CC.6070907@broadcom.com>	 <1434448766.21949.9.camel@embedded.rocks>
		 <55803214.2030204@broadcom.com> <1434608018.5481.4.camel@embedded.rocks>
		 <55828106.7060004@broadcom.com> <1434658050.2532.6.camel@embedded.rocks>
	 <55872A3C.7030704@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

On So, 2015-06-21 at 23:18 +0200, Arend van Spriel wrote:
> 
> My bad. The patch removes p2pdev from interface modes, but it is 
> still
> listed in the interface combinations and cfg80211 will complain about
> it. Have to extend the patch. I better do that after a good nights 
> sleep.

Never mind! Did you had a good night sleep already :-) ?

Best regards
Jörg Krause
