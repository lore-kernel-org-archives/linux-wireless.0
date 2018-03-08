Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:52117 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933489AbeCHO2w (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 8 Mar 2018 09:28:52 -0500
Received: by mail-wm0-f54.google.com with SMTP id h21so11662120wmd.1
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2018 06:28:52 -0800 (PST)
Date: Thu, 8 Mar 2018 15:28:47 +0100 (CET)
From: Enrico Mioso <mrkiko.rs@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Jamie Stuart <jamie@onebillion.org>,
        Daniel Golle <daniel@makrotopia.org>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
In-Reply-To: <20180308093938.GA2266@redhat.com>
Message-ID: <alpine.LNX.2.21.99.1803081526470.14437@mStation.localdomain> (sfid-20180308_152856_937209_7888E204)
References: <20180103113540.GA10306@redhat.com> <alpine.LNX.2.21.99.1801031503370.8405@localhost.localdomain> <CAKR_QVLRwAA0NJSarX46J4A8XSp8h5SuTEtSBQ4ydpEPh_-aUw@mail.gmail.com> <alpine.LNX.2.21.99.1801220643400.32225@mStation.localdomain>
 <20180123132234.GC2520@redhat.com> <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain> <20180124100316.GB3101@redhat.com> <20180301153006.GJ1233@makrotopia.org> <20180307122701.GA10584@redhat.com> <7B51BD3B-CAC3-479B-B06E-637A1C3A678A@onebillion.org>
 <20180308093938.GA2266@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-2133802759-1520519329=:14437"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-2133802759-1520519329=:14437
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT

BTW, the problem triggered today on my MR200 (first one), on channel 11, only one iPhone.
OpenWrt configuration was typical, the only change I made was encryption (psk2), and adding an encryption key.
all the rest comes directly from OpenWrt wifi detect feature.

[ 2761.755086] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.764577] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.774035] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.783492] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.792916] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.802359] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.811802] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.821250] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.830693] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.840136] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.849580] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.859028] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.868470] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.877911] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.887352] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.896793] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.906235] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.915676] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.925118] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.934567] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.944009] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.953450] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.962867] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.972309] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.981750] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2761.991191] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.000632] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.010076] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.019518] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.028955] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.038398] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.047840] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.057282] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.066724] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.076164] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.085605] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.095046] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2
[ 2762.104488] ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping frame due to full tx queue 2

I know this report is quite useless, but still.

On Thu, 8 Mar 2018, Stanislaw Gruszka wrote:

> Date: Thu, 8 Mar 2018 10:39:39
> From: Stanislaw Gruszka <sgruszka@redhat.com>
> To: Jamie Stuart <jamie@onebillion.org>
> Cc: Daniel Golle <daniel@makrotopia.org>, Enrico Mioso <mrkiko.rs@gmail.com>,
>     Tom Psyborg <pozega.tomislav@gmail.com>,
>     linux-wireless <linux-wireless@vger.kernel.org>,
>     Johannes Berg <johannes.berg@intel.com>, Arnd Bergmann <arnd@arndb.de>,
>     John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
>     Mathias Kresin <dev@kresin.me>
> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
>     frame due to full tx queue...?
> 
> Hi
>
> On Wed, Mar 07, 2018 at 05:47:34PM +0200, Jamie Stuart wrote:
>> config wifi-device 'radio0'
>> 	option type 'mac80211'
>> 	option channel 'auto'
>
> To make reproducible testing results I would suggest to setup a channel,
> (choose one that is the less used by other wireless networks),
> problem may happen on some channels and not happen on other.
>
>> The 30 clients are all Apple iPads (a mixture of iPad mini and mini 2, running iOS 9-11). During this testing period, all clients were simultaneously downloading files from the devices’ sdcard (served via nginx running on the device). Although this is not a typical use-case, it was useful in stress-testing the wireless setup.
>
> For such scenario I would suggest hardcode ba_size = 0 and see if that
> would help.
>
> I also attach another patch, can be applied on top of two previous.
> This one should give RX hardware more time to provide proper BlockACK
> frame, so hopefully could help with seq mismashes.
>
> Stanislaw
>
--8323329-2133802759-1520519329=:14437--
