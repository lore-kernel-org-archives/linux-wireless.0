Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:54954 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476Ab2FMLRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:17:53 -0400
Received: by eeit10 with SMTP id t10so151309eei.19
        for <linux-wireless@vger.kernel.org>; Wed, 13 Jun 2012 04:17:52 -0700 (PDT)
From: Erwin Van de Velde <erwin.vandevelde@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k bug in country domain handling
Date: Wed, 13 Jun 2012 13:17:49 +0200
Message-ID: <9709270.9fbk3VIit7@sylvesterjr.cmi.ua.ac.be> (sfid-20120613_131756_508223_3409151B)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have 802.11n cards with an atheros chipset with no default country domain. 
Upon initialization, crda is set to US domain, after which I try to change it 
to another domain, the driver only accepts further limitations: i.e. if a 
channel is allowed in the US but not in Belgium, it is disabled, but the other 
way round: if a channel is not allowed in the US, but is allowed in Belgium it 
is not enabled. 

Regards,
Erwin

