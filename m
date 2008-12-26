Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cp-out12.libero.it ([212.52.84.112]:40334 "EHLO
	cp-out12.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbYLZPDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Dec 2008 10:03:25 -0500
From: Fabio Rossi <rossi.f@inwind.it>
To: Meelis Roos <mroos@linux.ee>
Subject: Re: RT2500 scan problem in 2.6.28
Date: Fri, 26 Dec 2008 16:02:47 +0100
Cc: linux-wireless@vger.kernel.org
References: <Pine.SOC.4.64.0812261259030.13693@math.ut.ee> <200812261342.43875.rossi.f@inwind.it> <Pine.SOC.4.64.0812261651120.16847@math.ut.ee>
In-Reply-To: <Pine.SOC.4.64.0812261651120.16847@math.ut.ee>
MIME-Version: 1.0
Message-Id: <200812261602.47659.rossi.f@inwind.it> (sfid-20081226_160343_347271_9E64958B)
Content-Type: text/plain;
  charset="iso-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 December 2008, Meelis Roos wrote:

> > wireless-testing there's included a patch for associating to hidden
> > networks when SSID=''. You can see the SSID value with iwlist <if>
> > scanning.
>
> Oh, so this is known - I'll just wait for it to be merged upstream then.

If this is the problem I don't know how you were able to associate previously 
with the 2.6.27 vanilla kernel.

Fabio
