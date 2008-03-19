Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:19821 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760634AbYCSTx4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Mar 2008 15:53:56 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: Re: [RFC] libertas: change quality calculation
Date: Wed, 19 Mar 2008 16:50:53 +0100
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org
References: <200803181510.52726.hs4233@mail.mn-solutions.de> <200803191625.39210.hs4233@mail.mn-solutions.de> <1205941097.4169.23.camel@localhost.localdomain>
In-Reply-To: <1205941097.4169.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200803191650.53769.hs4233@mail.mn-solutions.de> (sfid-20080319_195443_351901_1E7D9229)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> RSSI can be derived by adding Noise Floor to SNR value

I saw that, and it's actually like this coded. However, I was 
wondering if it is allowed to add "dBm" to "dB". Those are the 
documented units for "noisefloor" and "SNR", respectively.

See my question about this with the subject "Re: [RFC PATCH] 
mac80211: use hardware flags for signal/noise units".



Anyway, the reported quality from scan is similar (not identical) 
to the reported quality for iwconfig, so for my purpose it's 
good enought (BTW: it wasn't identical before my patches).
