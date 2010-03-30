Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Cpsmtpm-eml107.kpnxchange.com ([195.121.3.11]:55438 "EHLO
	CPSMTPM-EML107.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755320Ab0C3FK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 01:10:56 -0400
Message-ID: <4BB187DF.5020203@gmail.com>
Date: Tue, 30 Mar 2010 07:10:55 +0200
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
Subject: Re: FW RT307x/RT309x
References: <4BB11AA4.3010108@gmail.com>
In-Reply-To: <4BB11AA4.3010108@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/29/10 23:24, Xose Vazquez Perez wrote:
> hi,
> 
> to make the RT307x and RT309x chips work, the drivers
> rt2800usb and rt2800pci need to load rt307x.bin and
> rt3090.bin respectively. 
> 
> FW is here:http://git.decadent.org.uk/gitweb?p=linux-firmware.git;a=tree
> 

Xose,

Note that this is something that was done by a staging driver developer.
The original Ralink provided drivers simply always load rt2860.bin or
rt2870.bin.
AFAICT these firmware files are universally applicable to rt2800, rt30xx,
rt33xx, and rt35xx devices.

---
Gertjan.
