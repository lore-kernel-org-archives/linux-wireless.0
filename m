Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:57397 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab3EIBXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 May 2013 21:23:24 -0400
Received: by mail-pd0-f171.google.com with SMTP id r11so1657213pdi.16
        for <linux-wireless@vger.kernel.org>; Wed, 08 May 2013 18:23:24 -0700 (PDT)
Subject: Re: atheros AR5B22, using ath9k, can't switch between inscure and
 WEP/WPA
From: Wally <wally.yeh@a-trust.com.tw>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAJ-Vmonq1YN2NoWFMXtqVYr16eTD=mZ0n74CCEhMHK=05M1xyQ@mail.gmail.com>
References: <1368015905.17674.11.camel@bigdick-desktop>
	 <CAJ-Vmonq1YN2NoWFMXtqVYr16eTD=mZ0n74CCEhMHK=05M1xyQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 May 2013 09:28:03 +0800
Message-ID: <1368062883.17674.24.camel@bigdick-desktop> (sfid-20130509_032330_038688_3F03F6FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Adrian:
    Here is it's wiki:http://wikidevi.com/wiki/Atheros_AR5B22

    As I modprobe ath9k. dmesg give these messages:
----------------------------------------------------------------------
[49603.281250] compat-drivers backport release:
compat-drivers-2013-03-28
[49603.281250] Backport based on linux-next.git next-20130328
[49603.281250] compat.git: linux-next.git
[49603.367187] cfg80211: Calling CRDA to update world regulatory domain
[49603.609375] ath: EEPROM regdomain: 0x60
[49603.609375] ath: EEPROM indicates we should expect a direct regpair
map
[49603.609375] ath: Country alpha2 being used: 00
[49603.609375] ath: Regpair used: 0x60
[49603.609375] ieee80211 phy0: Selected rate control algorithm
'ath9k_rate_control'
[49603.609375] Registered led device: ath9k-phy0
[49603.609375] ieee80211 phy0: Atheros AR9462 Rev:2 mem=0xe1300000,
irq=48
-----------------------------------------------------------------------
    so it seems ath9k probe this chip as Atheros AR9462. do you have
some idea? 

Wally



於 三，2013-05-08 於 15:46 -0700，Adrian Chadd 提到：
> .. AR5B22? Which chip does that probe as?
> 
> 
> 
> Adrian
> 
> 
> On 8 May 2013 05:25, Wally <wally.yeh@a-trust.com.tw> wrote:
> > Hi, guys:
> >     Recently I got a atheros mini-PCIE wifi module AR5B22, so I download
> > the latest version of compat-driver(compat-drivers-2013-03-28.tar.gz),
> > and build it for armel on my arm board, it works great but with one
> > little problem:
> >
> > If I connect to an inscure AP then change to a WEP/WPA AP, I can't
> > connect the inscure one again, I have to run "modprobe -r ath9k;
> > modprobe ath9k" to connect the inscure AP.
> >
> >     I think this may be a bug in the ath9k driver, I also search this
> > bug on web but without an answer, so I send this letter for help.
> >
> >     Any advice would be grateful, thanks.
> >
> > Wally
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html


