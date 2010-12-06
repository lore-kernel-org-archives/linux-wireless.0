Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from uhura.skim.hs-owl.de ([193.174.118.81]:33473 "EHLO
	uhura.skim.hs-owl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab0LFRNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 12:13:40 -0500
Message-ID: <4CFD1620.5070708@hs-owl.de>
Date: Mon, 6 Dec 2010 17:58:08 +0100
From: "Stefan Schwalowsky (inIT)" <stefan.schwalowsky@hs-owl.de>
MIME-Version: 1.0
To: <linux-wireless@vger.kernel.org>
CC: ath5k-devel list <ath5k-devel@lists.ath5k.org>
Subject: How to get medium (carrier-sense) information from Atheros chipsets?
Content-Type: text/plain; charset="ISO-8859-15"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
I'm working on a research project dealing with real-time capabilities of 
WLAN. Currently I'm analyzing the ATH5K driver and trying to find a way 
to get information about the medium state (carrier-sense state) . I want 
to check whether the medium is currently occupied by other stations or 
not. Is there a way to get the carrier sense information from the 
hardware through a status-register or so? (Currently we have a AR5413 
Chip, but any other would also be OK)  The only information i found was 
about the profile count registers, which doesn't really meet our 
requirements.

I greatly appreciate your help

Kind regards
Stefan Schwalowsky

