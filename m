Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:41751 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYLZMqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 07:46:31 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Meelis Roos <mroos@ut.ee>
Subject: Re: RT2500 scan problem in 2.6.28
Date: Fri, 26 Dec 2008 13:42:43 +0100
Cc: linux-wireless@vger.kernel.org
References: <Pine.SOC.4.64.0812261259030.13693@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0812261259030.13693@math.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200812261342.43875.rossi.f@inwind.it> (sfid-20081226_134634_733441_122FCD4F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 December 2008, Meelis Roos wrote:

> Hello,
>
> I finally found a network where rt2x00 driver works reliably (using
> 2.6.27). However, it does not work anymore with 2.6.28.
>
> The network uses hidden SSID so wpa_supplicant is configured with
> ap_scan to find it. This works fine in 2.6.27 but the scan fails with
> 2.6.28. Rugging wpa_supplicant in debug mode tells the scan finds a
> network with ssid='' and it does not match.
>
> How can I debug it some more? I'm here with the network today and
> tomorrow, then I will leav for home.

Hi Meelis,
are you using the official kernel release or wireless-testing? In 
wireless-testing there's included a patch for associating to hidden networks 
when SSID=''. You can see the SSID value with iwlist <if> scanning.

Fabio
