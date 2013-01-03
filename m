Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.11]:52258 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3ACJdJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 04:33:09 -0500
Date: Thu, 3 Jan 2013 10:31:50 +0100
From: Julian Wollrath <jwollrath@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/wireless/mlme.c:517
Message-ID: <20130103103150.21ed1269@ilfaris> (sfid-20130103_103313_695381_D9B15659)
In-Reply-To: <50E467C4.6030602@lwfinger.net>
References: <20130101154507.351dfb03@ilfaris>
	<50E325B5.205@lwfinger.net>
	<20130101231544.430cf1fe@ilfaris>
	<50E36325.3090502@lwfinger.net>
	<20130102120002.691dbbb4@ilfaris>
	<50E467C4.6030602@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> I have not looked at detail at the debug listing, but I do have
> additional questions. None of your Emails on this subject mention
> anything about the AP. What make/model is it? What firmware is it
> running? Is it 802.11g or 802.11n? What are the details of the
> encryption? The device authenticates but is never able to associate
> after that.
One device is a NETGEAR WN3000RP and it uses WPA-PSK and TKIP as cipher
but similar problems accured at university where WPA2 is used and the
AP are probably not the same there (I can check it next monday). Here
is the output of "iw dev wlan0 scan", which hopefully answers your
questions which I did not answer above:
BSS xx:xx:xx:xx:xx:xx (on wlan0)
	freq: 2462
	beacon interval: 100
	capability: ESS Privacy ShortSlotTime (0x0411)
	signal: -48.00 dBm
	last seen: 143 ms ago
	Information elements from Probe Response frame:
	SSID: xxx
	Supported rates: 1.0* 2.0* 5.5 11.0 18.0 24.0 36.0 54.0 
	DS Parameter set: channel 11
	ERP: Use_Protection Barker_Preamble_Mode
	Extended supported rates: 6.0 9.0 12.0 48.0 
	WPS:	 * Version: 1.0
		 * Wi-Fi Protected Setup State: 2 (Configured)
		 * Selected Registrar: 0x0
		 * Response Type: 3 (AP)
		 * UUID: xxx
		 * Manufacturer: NETGEAR, Inc.
		 * Model: WN3000RP
		 * Model Number: WN3000RP
		 * Serial Number: 01
		 * Primary Device Type: 6-0050f204-1
		 * Device name: WN3000RP
		 * Config methods: Label, PBC
		 * RF Bands: 0x1
	WPA:	 * Version: 1
		 * Group cipher: TKIP
		 * Pairwise ciphers: TKIP
		 * Authentication suites: PSK
		 * Capabilities: 16-PTKSA-RC (0x000c)
	WMM:	 * Parameter version 1
		 * u-APSD
		 * BE: CW 15-1023, AIFSN 3
		 * BK: CW 15-1023, AIFSN 7
		 * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
		 * VO: CW 3-7, AIFSN 2, TXOP 1504 usec

If it does not answer all of your questions, a hint, how to find the
answers without access (physical or otherwise) to the AP would be
appreciated.


With best regards,
Julian
