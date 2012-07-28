Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:36149 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2G1PZ0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jul 2012 11:25:26 -0400
Received: by qcro28 with SMTP id o28so2315256qcr.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jul 2012 08:25:25 -0700 (PDT)
Message-ID: <50140463.3080209@lwfinger.net> (sfid-20120728_172530_159784_BB53DC58)
Date: Sat, 28 Jul 2012 10:25:23 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <500EE086.6000304@lwfinger.net> <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343236780.36289.YahooMailNeo@web28901.mail.ir2.yahoo.com> <1343237104.35808.YahooMailNeo@web28905.mail.ir2.yahoo.com> <5010304E.6070005@lwfinger.net> <1343296732.22680.YahooMailNeo@web28905.mail.ir2.yahoo.com> <501121B5.4010305@lwfinger.net> <1343300503.96939.YahooMailNeo@web28902.mail.ir2.yahoo.com> <501129D9.4060407@lwfinger.net> <1343314190.31952.YahooMailNeo@web28901.mail.ir2.yahoo.com> <5011BC0A.8060600@lwfinger.net> <1343370892.97699.YahooMailNeo@web28904.mail.ir2.yahoo.com> <501280BF.4070409@lwfinger.net> <1343394581.87030.YahooMailNeo@web28902.mail.ir2.yahoo.com> <1343398356.19742.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343403507.54955.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343404770.91235.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com>
In-Reply-To: <1343407089.96532.YahooMailNeo@web28901.mail.ir2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/27/2012 11:38 AM, Xavier de Almeida wrote:
> Without touching anything it started to work:
>
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-ASSOCIATE.indication(88:30:8a:52:ed:cd)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: event 1 notification
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: start authentication
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: unauthorizing port
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: received EAPOL-Key frame (2/4 Pairwise)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: sending 3/4 msg of 4-Way Handshake
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: received EAPOL-Key frame (4/4 Pairwise)
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: authorizing port
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd RADIUS: starting accounting session 5012BD3F-00000000
> Jul 27 18:34:27 HTPC hostapd: wlan0: STA 88:30:8a:52:ed:cd WPA: pairwise key handshake completed (RSN)
>
> but the signal is very weak so maybe that was one of the issues.
>
> I am looking fwd to remove the power mgt stuff and maybe find out how to increase the signal power. Maybe I should be a kind of antennat but not sure this will work with a barebone like the xs36v.

I run mine, when I test AP mode, without any options.

I'm glad you got it working. Now you know why I recommend spending 40 euro for 
an AP rather than trying to use a 600 euro computer for that purpose. BTW, I own 
4 AP/routers.

Larry




