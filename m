Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canee.jelmoni.net ([188.40.108.53]:51973 "EHLO
	canee.jelmoni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751609Ab1G3MN1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jul 2011 08:13:27 -0400
Received: from localhost (localhost [127.0.0.1])
	by canee.jelmoni.net (Postfix) with ESMTP id 52B291102DB
	for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 14:03:36 +0200 (CEST)
Received: from canee.jelmoni.net ([127.0.0.1])
	by localhost (scai.jelmoni.net [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pbHCXcsDchw7 for <linux-wireless@vger.kernel.org>;
	Sat, 30 Jul 2011 14:03:34 +0200 (CEST)
Received: from [192.168.177.184] (host162.190-226-71.telecom.net.ar [190.226.71.162])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: bmeier@swiss-wireless.com.ar)
	by canee.jelmoni.net (Postfix) with ESMTPSA id D9674110281
	for <linux-wireless@vger.kernel.org>; Sat, 30 Jul 2011 14:03:33 +0200 (CEST)
Message-ID: <4E33F30D.80807@swiss-wireless.com.ar> (sfid-20110730_141331_419934_B59C84C8)
Date: Sat, 30 Jul 2011 09:03:25 -0300
From: Beat Meier <mbe_ml@swiss-wireless.com.ar>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: What about long distance links in 5.8GHz with ath5k?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello

I try to use the new ath5k drivers instead of madwifi with long distance 
links (8km-20km) at 5.8GHz
I have not found how to configure the distance settings link in madwifi 
and I have really bad throughout
with ath5k driver as client using wpa_supplicant.

Client: Alix board with voyage-0.7.5 (wpa_supplicant 0.7.3), Radio 
WL54AGP23 (168C:001B)
Server: wrap board with voyage-0.5.0 (madwifi-0.9.4 / hostapd 0.5.5), 
Radio WL54AGP23(168C:001B)

Output of the 8km link tests:
The rate is set fix to 24M on both sites for iperf tests

Signal on sta (ath5k driver): -60dbm       iperf server running on sta: 
9Mbps
Signal on ap (madwifi driver): -64dbm   (-65dbm noise -96)  iperf server 
running on ap: 400kbps-1.2Mbps

Signal on sta (madwifi driver): -51dbm (-42dbm noise -85)   iperf server 
running on sta: 12.5Mbps
Signal on ap (madwifi driver): -53dbm (-54dbm noise -96)   iperf server 
running on ap: 10.3Mbps

If I use ath5k on server with hostapd i.e. voyage-0.7.5 the client does 
connect and disconnect there
is no link established...

Any hints/solutions/experiences?

Greetings

Beat



