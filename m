Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nexus.dynaweb.hu ([195.70.37.87]:57944 "EHLO nexus.dynaweb.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024AbYKLXqd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2008 18:46:33 -0500
Date: Thu, 13 Nov 2008 00:46:32 +0100
From: RUMI Szabolcs <rumi_ml@rtfm.hu>
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath5k master (AP) mode
Message-Id: <20081113004632.d8d821c5.rumi_ml@rtfm.hu> (sfid-20081113_004638_126705_EE20E641)
In-Reply-To: <1226530010.15173.0.camel@dv>
References: <20081112224810.8d4ca179.rumi_ml@rtfm.hu>
	<1226530010.15173.0.camel@dv>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 12 Nov 2008 17:46:50 -0500
Pavel Roskin <proski@gnu.org> wrote:

> On Wed, 2008-11-12 at 22:48 +0100, RUMI Szabolcs wrote:
> > Hello!
> > 
> > I've been trying to set an Atheros NIC to AP mode using the ath5k
> > driver but it fails:
> > 
> > # iwconfig wlan0 mode master
> > Error for wireless request "Set Mode" (8B06) :
> >     SET failed on device wlan0 ; Invalid argument.
> 
> You need to use hostapd for master mode.

Well, I have installed hostapd-0.6.5 with the nl80211 driver and it says:

# hostapd -dd /etc/hostapd/hostapd.conf
Configuration file: /etc/hostapd/hostapd.conf
ctrl_interface_group=0
Failed to set interface wlan0 to master mode.
nl80211 driver initialization failed.
wlan0: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory
ELOOP: remaining socket: sock=8 eloop_data=0x9f4ea98 user_data=(nil) handler=0x8082920

Thanks,

Sab
