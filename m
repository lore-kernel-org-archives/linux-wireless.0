Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.30]:37635 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYJaQ0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2008 12:26:30 -0400
Message-ID: <40f31dec0810310926p6edd0af5o24d7616eb54c6d0@mail.gmail.com> (sfid-20081031_172635_406042_8CDD1FC4)
Date: Fri, 31 Oct 2008 18:26:28 +0200
From: "Nick Kossifidis" <mickflemm@gmail.com>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Subject: Re: ath5k gets lost with eeepc-laptop removal
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	willy@linux.intel.com, lrodriguez@atheros.com
In-Reply-To: <20081031110502.18e33eba@doriath.conectiva>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081031110502.18e33eba@doriath.conectiva>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2008/10/31 Luiz Fernando N. Capitulino <lcapitulino@mandriva.com.br>:
>
>  Hi guys,
>
>  If I do a 'rmmod eeepc-laptop', while connected to my AP, I get the
> following error messages from ath5k:
>
> """
> ath5k phy0: noise floor calibration timeout (2417MHz)
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: can't reset hardware (-5)
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: can't reset hardware (-5)
> wlan0: No ProbeResp from current AP 00:1d:0f:e9:c7:c0 - assume out of range
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2412 Mhz)
> wlan0: failed to set freq to 2412 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2417 Mhz)
> wlan0: failed to set freq to 2417 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2422 Mhz)
> wlan0: failed to set freq to 2422 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2427 Mhz)
> wlan0: failed to set freq to 2427 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2432 Mhz)
> wlan0: failed to set freq to 2432 MHz for scan
> wlan0: failed to set freq to 2437 MHz for scan
> wlan0: failed to set freq to 2442 MHz for scan
> wlan0: failed to set freq to 2447 MHz for scan
> wlan0: failed to set freq to 2452 MHz for scan
> wlan0: failed to set freq to 2457 MHz for scan
> wlan0: failed to set freq to 2462 MHz for scan
> wlan0: failed to set freq to 2467 MHz for scan
> wlan0: failed to set freq to 2472 MHz for scan
> wlan0: failed to set freq to 2484 MHz for scan
> wlan0: failed to restore operational channel after scan
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authentication with AP 00:1d:0f:e9:c7:c0 timed out
> """
>
>  Then I lost my wireless connection.
>
>  I'm running latest Linus git tree (2.6.28-rc2) on a Eeepc 701.
>
>  The problem doesn't happen on 2.6.27.4, but as 2.6.28-rc1 doesn't
> boot on this machine, it would be a bit difficult to bisect it.
>
>  Thanks.
>

After this does ath_info work ?


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
