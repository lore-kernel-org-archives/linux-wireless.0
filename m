Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blu0-omc4-s23.blu0.hotmail.com ([65.55.111.162]:5524 "EHLO
	blu0-omc4-s23.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757260Ab1F0LS3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 07:18:29 -0400
Message-ID: <BLU158-w3443764A60DE4B497231DB87570@phx.gbl> (sfid-20110627_132951_027154_EB684448)
From: Fred Matthews <fredmm@hotmail.co.uk>
To: <ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>
Subject: STBC functionality details request
Date: Mon, 27 Jun 2011 12:18:28 +0100
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hi,
I am using STBC (Space Time Block Coding) 1 stream NICs like the AR9280.I would be very grateful someone can kindly advise on how exactly STBC(transmits multiple copies of a data across each of the antennas) works in ath9k.
I ask this because when I enable STBC 1-stream, the driver seems to uses Space division multiplexing (can this be disabled/enabled?), since the rate is over 150Mbps.
When is STBC activated ?, ...Does Minstrel/ath9k rate adaptation mechanism find first check if Spatial multiplexing is better, if not uses STBC ?
Thank you for your time 		 	   		  