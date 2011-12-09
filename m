Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:42565 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752009Ab1LISFn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 13:05:43 -0500
Message-ID: <4EE24DF4.4020301@gmx.net> (sfid-20111209_190547_221035_E418966D)
Date: Fri, 09 Dec 2011 19:05:40 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net> <1323446534.13074.96.camel@wwguy-huron>
In-Reply-To: <1323446534.13074.96.camel@wwguy-huron>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/11 17:02, Guy, Wey-Yi wrote:
> Hi Wolfgang,
> 
> I don't have the similar AP here for testing. by looking at the log,
> looks like there is a issue while you scan.
> 
> Could you please try this patch and see if make any different? it is a
> long shot, but I just like to see if it make any different at all
> 
> once you apply the patch, please make sure P2P is disabled in .config

Done that... iwlwifi says...
> [  833.360213] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUG enabled
> [  833.360215] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEBUGFS enabled
> [  833.360217] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_TRACING disabled
> [  833.360219] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_DEVICE_SVTOOL enabled
> [  833.360222] iwlwifi 0000:43:00.0: CONFIG_IWLWIFI_P2P disabled
> [  833.360228] iwlwifi 0000:43:00.0: Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74

But it still occurs. This time it started again right after the 2.
rekeying event. wpa_supplicant logged.
> Associated with 00:80:48:xx:xx:xx
> WPA: Key negotiation completed with 00:80:48:xx:xx:xx [PTK=CCMP GTK=TKIP]
> CTRL-EVENT-CONNECTED - Connection to 00:80:48:xx:xx9:xx completed (reauth) [id=0 id_str=]
> WPA: Group rekeying completed with 00:80:48:xx:xx:xx [GTK=TKIP]
> WPA: Group rekeying completed with 00:80:48:xx:xx:xx [GTK=TKIP]

I failed to mention that I used F14 with compat-wireless from arround
march of 2011 before I upgraded to F16 in my first mail. With this
version I had no troubles with the exactly same AP and my 2540p.

Greetings, Wolfgang
..



> 
> Thanks
> Wey
