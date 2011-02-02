Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:45607 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754994Ab1BBTIe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 14:08:34 -0500
To: Brian Prodoehl <bprodoehl@gmail.com>
Cc: James <bjlockie@lockie.ca>,
	linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Subject: Re: did compat-wireless-2011-01-27 crash dhcpcd?
References: <4D41DAF1.6080204@lockie.ca> <4D41ED24.9010005@hauke-m.de>
	<4D41FDF7.3040805@lockie.ca>
	<AANLkTi=4rvKYSDiHNoM0YHMAd=nSmi=DELOp+9nxCwAM@mail.gmail.com>
	<4D438320.1000800@lockie.ca>
	<AANLkTimWKr_Dwxe0dSAnL6O1Z7GnxChZk6k1aoThdAWV@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 02 Feb 2011 21:08:32 +0200
In-Reply-To: <AANLkTimWKr_Dwxe0dSAnL6O1Z7GnxChZk6k1aoThdAWV@mail.gmail.com> (Brian Prodoehl's message of "Sat\, 29 Jan 2011 01\:31\:06 -0500")
Message-ID: <87wrli9rv3.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Brian Prodoehl <bprodoehl@gmail.com> writes:

> I dug through the source of dhcpcd a bit, and it uses wext to fetch
> the SSID.  So, maybe that does explain it.  I guess the real fix is
> for dhcpcd to get updated to use nl80211.

You got me curious now. Why does dhcpd need ssid?

-- 
Kalle Valo
