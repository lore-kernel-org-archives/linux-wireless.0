Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:33066 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758719AbYDUO2g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 10:28:36 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1Jnx0V-0005jK-Gy
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 15:28:35 +0100
Message-ID: <480CA491.6090702@fenrir.org.uk> (sfid-20080421_162927_710970_37FA5D8A)
Date: Mon, 21 Apr 2008 15:28:33 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>
In-Reply-To: <1208785818.26186.101.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
>> If you're in the EU, I contributed a fix that has not yet made it into 
>> the iwlwifi code as it is under review (the whole regulatory aspect is 
>> difficult, there are so many caveats!).
> 
> Technically, it's cfg80211 code; the reason that it's not in yet is that
> I'm unsure about the legal situation of the ETSI and the national
> bodies, it seems to me that the ultimate decision is done by the
> national bodies and last I heard France had quite different restrictions
> than Germany, for example.
> 
> Does anyone have that info? I can dig up the info for Germany easily
> (the "Frequenznutzungsplan" is available on the regulatory agency web
> site as pdf)

Further to my previous comment, here is another press release:

http://www.arcep.fr/index.php?id=8571&L=1&tx_gsactualite_pi1[uid]=214&tx_gsactualite_pi1[annee]=0&tx_gsactualite_pi1[theme]=0&tx_gsactualite_pi1[motscle]=WLAN%20Wifi&tx_gsactualite_pi1[backID]=2122&cHash=48ad69deb0

Indicating that all 100 departements now allow the same conditions as 
those applied to the 58 listed in the previous document.

Oh, and:

http://www.arcep.fr/index.php?id=8571&L=1&tx_gsactualite_pi1[uid]=944&tx_gsactualite_pi1[annee]=0&tx_gsactualite_pi1[theme]=0&tx_gsactualite_pi1[motscle]=WLAN%20Wifi&tx_gsactualite_pi1[backID]=2122&cHash=15247b0fd6

has some diagrams showing this and detailing some more information about 
5GHz and overseas French territories.

-- 

Brian
