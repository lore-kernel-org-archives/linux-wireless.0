Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab2JWMnZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Oct 2012 08:43:25 -0400
Message-ID: <1350996238.10322.7.camel@jlt4.sipsolutions.net> (sfid-20121023_144329_495484_F540426A)
Subject: Re: TR: Clear data transit during WPA negociation in case of
 reassociation
From: Johannes Berg <johannes@sipsolutions.net>
To: Cedric Debarge <cedric.debarge@acksys.fr>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 23 Oct 2012 14:43:58 +0200
In-Reply-To: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local> (sfid-20121018_094934_139014_F8666167)
References: <773DB8A82AB6A046AE0195C68612A31901411778@sbs2003.acksys.local>
	 (sfid-20121018_094934_139014_F8666167)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-10-18 at 09:30 +0200, Cedric Debarge wrote:
> Hi all,
> 
> 	I am not sure if this is the right place to post my question. Please forgive me if not.
> 
> 	I am experimenting roaming between two APs with wpa_supplicant (WPA2 + EAP-TLS).
> 	When WPA_Supplicant come back from an AP for which it has already cached the key, I saw that during WPA2 4 Handshake (in case of reassociation), data are sent through wpa_supplicant unencrypted.
> 
> 	As soon as the WPA2 successfully ends its negotiation, the data are sent encrypted back.
> 
> 	I attached to this email a Wireshark capture of the wireless transaction. Before this capture the frames were correctly encrypted. 
> 	You can see the start of the WPA2 4 Handshake protocol at packet number 10.
> 	During this 4 Handshake protocol you could see unencrypted iperf (UDP 5001) packets N°12/17/18/22/24.. until packet 55. 
> 	4 Handshake protocol ends at packet 49.
> 
> 	Can you give me some clue how to work it out ?

Can you show the wpa_supplicant debug log for this?

johannes

