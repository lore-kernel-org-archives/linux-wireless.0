Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx.fenrir.org.uk ([81.168.115.223]:33278 "EHLO mx.fenrir.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbYDUPBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Apr 2008 11:01:43 -0400
Received: from [62.189.241.202] (helo=[10.104.10.102])
	(TLSv1:AES256-SHA:256)
	by mx.fenrir.org.uk with esmtpsa (Exim 4.69 #1 (Red Hat Linux))
	id 1JnxWY-0005li-7V
	for <linux-wireless@vger.kernel.org>; Mon, 21 Apr 2008 16:01:42 +0100
Message-ID: <480CAC55.1000704@fenrir.org.uk> (sfid-20080421_170234_346603_44E35F3C)
Date: Mon, 21 Apr 2008 16:01:41 +0100
From: Brian Morrison <bdm@fenrir.org.uk>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [ipw3945-devel] iwl3945: Disabled channels
References: <fuhkfp$mnk$1@ger.gmane.org>  <480C5AFF.5020005@fenrir.org.uk>	 (sfid-20080421_101455_395583_495A4EE6) <1208785818.26186.101.camel@johannes.berg>	 <480CA260.70506@fenrir.org.uk> (sfid-20080421_162006_486515_D95FEC5E) <1208788898.26186.105.camel@johannes.berg>
In-Reply-To: <1208788898.26186.105.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> 
> I can't say I particularly care about France, but even from the
> wikipedia page you linked previously it is rather clear that we cannot
> define a "EU" regulatory domain because Spain and France are in the EU
> yet have not adopted the "European" regulatory requirements.

That makes it all very difficult, I think that an EU domain is OK 
provided that there is also a Spanish domain. Or maybe the EU domain 
should actually be named ETSI (which was my original preference, it was 
John Linville that said EU hence why I used it).

I'll have to see if I can work out what the allowable domains are for 
the Ralink RT2500 drivers, under Windows for instance. I know that are 
are considerable number of choices, certainly more than US/EU/JP. That 
might provide a good clue.

I'm beginning to wonder if anyone has this correct in their shipping 
products, especially from a power point of view. The regulatory stuff is 
supposed to be prevented from manipulation by the user, but if I were in 
the US and I entered "JP" for the regdom, then I can break the regs with 
nothing to stop me anyway. You couldn't operate with a worldwide lowest 
common denominator approach, it would be the equivalent of turning the 
wireless hardware off!

Does anyone know how the EEPROM contents are supposed to work for the 
Intel hardware? How they are queried and compared with kernel and 
userspace programs?

-- 

Brian
