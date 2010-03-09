Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:45738 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756516Ab0CICMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 21:12:54 -0500
Received: by qyk9 with SMTP id 9so5250103qyk.5
        for <linux-wireless@vger.kernel.org>; Mon, 08 Mar 2010 18:12:52 -0800 (PST)
Message-ID: <4B95AEA1.3040401@lwfinger.net>
Date: Mon, 08 Mar 2010 20:12:49 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Deauthentications with p54usb
References: <1756555272@web.de> <4A7F314E.7050808@lwfinger.net> <201003090038.34884.chunkeey@googlemail.com>
In-Reply-To: <201003090038.34884.chunkeey@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/08/2010 05:38 PM, Christian Lamparter wrote:
> Hello Larry,
> 
> Remember?

I had forgotten. Using the 'iwconfig wlanX power on' results in lots of
deauthentications:

The output of 'dmesg | grep deauthen' results in

[19826.645917] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20006.645407] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20126.663059] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20301.031865] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20366.659815] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20501.417748] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20606.644271] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20846.658392] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[20966.653835] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21095.942856] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21332.790772] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21446.649393] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21570.643913] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21686.652360] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[21946.714794] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[22078.162861] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[22166.651450] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[22406.651968] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[22526.667053] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[22646.651483] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23054.133847] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23139.129081] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23249.743447] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23377.759110] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23487.119197] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23622.154154] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23846.651794] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[23966.649980] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[24206.644314] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[24446.650418] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[24576.569191] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[24686.645975] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)
[24806.650948] wlan6: deauthenticated from 00:14:bf:85:49:fa (Reason: 7)

As soon as I used 'iwconfig wlanX power off', the deauthentications stopped.

Larry
