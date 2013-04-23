Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:52794 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755418Ab3DWJ6r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Apr 2013 05:58:47 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <20854.23253.514263.467205@gargle.gargle.HOWL> (sfid-20130423_115851_064045_41A70DFF)
Date: Tue, 23 Apr 2013 15:26:37 +0530
To: Gerry Gavigan <gerry@gavigan.f9.co.uk>
Cc: linux-wireless@vger.kernel.org
Subject: Re: ath9k problems on openSUSE 12.3
In-Reply-To: <2687000.szPz826eEU@linux-zd5t.site>
References: <d5546f49ab812cc89887b18b41d44da0@imap.force9.net>
	<20854.18866.135251.330099@gargle.gargle.HOWL>
	<2687000.szPz826eEU@linux-zd5t.site>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Gerry Gavigan wrote:
> - turned power save off
> - confirmed
> - shut down
> - restarted
> - power save is on
> 
> problem persists 

Ok.

Can you load the driver with more debugging options and post the kernel log ?
Please use the mask debug=0x8f49.

See http://wireless.kernel.org/en/users/Drivers/ath9k/debug

Sujith
