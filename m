Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web28510.mail.ukl.yahoo.com ([87.248.110.189]:32355 "HELO
	web28510.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751395AbYKAWUX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 18:20:23 -0400
Date: Sat, 1 Nov 2008 22:20:21 +0000 (GMT)
From: Julien HENRY <henryju@yahoo.fr>
Subject: Re : Re : Re : Not associated with Intel 4965
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-ID: <97506.7935.qm@web28510.mail.ukl.yahoo.com> (sfid-20081101_232029_397223_A2035E1A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

# iwconfig wlan0 essid "MiddleEarth" key s:XXXXXXXXX
Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.
# iwconfig
lo        no wireless extensions.

eth0      no wireless extensions.

sit0      no wireless extensions.

wmaster0  no wireless extensions.

wlan0     IEEE 802.11abgn  ESSID:"MiddleEarth"
          Mode:Managed  Frequency:2.442 GHz  Access Point: Not-Associat=
ed
          Tx-Power=3D15 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=3D2352 B
          Encryption key:3266-C437-9DA2-5422-18C3-2621-22BB-35D1-B24C-7=
E80-E99E-9850-AC21-4F8F-7779-18E3 [2]   Security mode:open
          Power Management:off
          Link Quality:0  Signal level:0  Noise level:0
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0

Not-associated. What this error means?

Error for wireless request "Set Encode" (8B2A) :
    SET failed on device wlan0 ; Invalid argument.




----- Message d'origine ----
De : Luis R. Rodriguez <mcgrof@gmail.com>
=C0 : Julien HENRY <henryju@yahoo.fr>
Cc : linux-wireless@vger.kernel.org
Envoy=E9 le : Samedi, 1 Novembre 2008, 23h16mn 12s
Objet : Re: Re : Re : Not associated with Intel 4965

On Sat, Nov 1, 2008 at 3:00 PM, Julien HENRY <henryju@yahoo.fr> wrote:
> OK, now I can load the module... but nothing better concerning associ=
ation.
>
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Using static regulatory d=
omain info
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Regulatory domain: JP
> Nov  1 22:39:24 Capgemini kernel:     (start_freq - end_freq @ bandwi=
dth), (max_antenna_gain, max_eirp)
> Nov  1 22:39:24 Capgemini kernel:     (2402000 KHz - 2494000 KHz @ 40=
000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel:     (5160000 KHz - 5250000 KHz @ 40=
000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel:     (5250000 KHz - 5330000 KHz @ 40=
000 KHz), (600 mBi, 2000 mBm)
> Nov  1 22:39:24 Capgemini kernel: cfg80211: Calling CRDA for country:=
 JP
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Intel(R) Wireless WiFi Link=
 AGN driver for Linux, 1.3.27ks
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Copyright(c) 2003-2008 Inte=
l Corporation
> Nov  1 22:39:24 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> G=
SI 17 (level, low) -> IRQ 17
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Detected Intel Wireless WiF=
i Link 4965AGN REV=3D0x4
> Nov  1 22:39:24 Capgemini kernel: iwlagn: Tunable channels: 13 802.11=
bg, 19 802.11a channels
> ...
> Nov  1 22:39:41 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> G=
SI 17 (level, low) -> IRQ 17
> Nov  1 22:39:41 Capgemini kernel: firmware: requesting iwlwifi-4965-2=
=2Eucode
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:rad=
io
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:ass=
oc
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:RX
> Nov  1 22:39:41 Capgemini kernel: Registered led device: iwl-phy0:TX
> Nov  1 22:39:41 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is=
 not ready
> Nov  1 22:39:41 Capgemini kernel: iwlagn: TX Power requested while sc=
anning!
> Nov  1 22:39:41 Capgemini kernel: iwlagn: Error sending TX power (-11=
)
>
> ...
> Nov  1 22:39:47 Capgemini kernel: iwlagn 0000:03:00.0: PCI INT A -> G=
SI 17 (level, low) -> IRQ 17
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:rad=
io
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:ass=
oc
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:RX
> Nov  1 22:39:47 Capgemini kernel: Registered led device: iwl-phy0:TX
> Nov  1 22:39:47 Capgemini kernel: ADDRCONF(NETDEV_UP): wlan0: link is=
 not ready
>
> Anything I can try?

Looks good to me. Try the usual commands/applications to connect to an
AP. I'm not going to help you with that.

  Luis



     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
