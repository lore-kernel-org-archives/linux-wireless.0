Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55759
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbXFTLRp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jun 2007 07:17:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Mandy.Peng@infineon.com
Subject: Re: FullMAC develop
Date: Wed, 20 Jun 2007 13:17:14 +0200
Cc: linux-wireless@vger.kernel.org
References: <A2CE5E0A70B68046A98EB5145552E2770112BDEF@sinse303.ap.infineon.com>
In-Reply-To: <A2CE5E0A70B68046A98EB5145552E2770112BDEF@sinse303.ap.infineon.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200706201317.14676.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 20 June 2007 12:57:14 Mandy.Peng@infineon.com wrote:
> 
> Dears,
> 
> We are plane to develop a FullMAC chipset. May I skip the ether to
> 802.11 frame transform since the chipset support all of the data path
> access to get high data throughput ?

Sure, if your device is a real fullmac device, you simply register
a regular netdevice and do your configuration through cfg80211
directly.

-- 
Greetings Michael.
