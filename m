Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out2.libero.it ([212.52.84.102]:48889 "EHLO
	cp-out2.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752448Ab1ECL1h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 07:27:37 -0400
Message-ID: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost> (sfid-20110503_132740_887698_255B41C5)
Date: Tue, 3 May 2011 13:27:12 +0200 (CEST)
From: "rossi.f@inwind.it" <rossi.f@inwind.it>
Reply-To: "rossi.f@inwind.it" <rossi.f@inwind.it>
To: <yogeshp@marvell.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: RE: WARNING: at net/mac80211/wep.c:101
 ieee80211_wep_add_iv+0x52/0x150 [mac80211]()
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>Da: yogeshp@marvell.com
>Data: 03/05/2011 12.51
>A: "rossi.f@inwind.it"<rossi.f@inwind.it>, "johannes@sipsolutions.net"
<johannes@sipsolutions.net>
>Cc: "linux-wireless@vger.kernel.org"<linux-wireless@vger.kernel.org>
>Ogg: RE: WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150 
[mac80211]()
>
>>I get the warning every few seconds.
>>
>>Fabio
>I failed to regenerate the issue on my setup. I am using WEP40 on
>Ath5k as station on 32 bit machine. I even tried disabling hw encryption.
>
>Some more details would be helpful.
>
>Thanks
>Yogesh

I'm using WEP with 128bit key on a 64bit system using ath5k driver. The hw 
encryption is configured with the default value. I don't have access right now 
to the machine, I can provide more details tonight if needed. I can test 
patches to diagnose the problem.

Regards,
Fabio


