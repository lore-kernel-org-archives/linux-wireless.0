Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:41889 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab0IFXQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Sep 2010 19:16:33 -0400
From: Fabio Rossi <rossi.f@inwind.it>
To: linux-wireless@vger.kernel.org
Subject: ath5k calibration error
Date: Tue, 7 Sep 2010 01:10:11 +0200
Cc: br1@einfach.org
MIME-Version: 1.0
Message-Id: <201009070110.11495.rossi.f@inwind.it>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the patch 9e04a7eb1fdf37bc8bc0d0f59e5fb737926f0152 there has been a change 
in the possible return values from ath5k_hw_rf511x_iq_calibrate().

Sometimes I get -1 (before that commit the return value was always 0) because 
i_coffd:0, q_coffd:0 and the following error message is produced:

  ath5k phy0: calibration of channel 8 failed

Of course I'm running on channel 8.

Is this condition normal or something is weird? I have the following card:

  3Com Corporation AR5212 802.11abg NIC (3CRDAG675) (rev 01)

Thanks,
Fabio
