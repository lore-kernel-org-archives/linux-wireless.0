Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:37635 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753388AbYJ2Amh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2008 20:42:37 -0400
Date: Wed, 29 Oct 2008 01:42:35 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-wireless@vger.kernel.org, linux-pcmcia@lists.infradead.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: 2.6.28-rc2: new PCMCIA device instance after resume - orinoco can't download firmware
Message-ID: <20081029004235.GA17879@isilmar.linta.de> (sfid-20081029_014241_663591_4C84C981)
References: <200810282219.51492.arvidjaar@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200810282219.51492.arvidjaar@mail.ru>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Tue, Oct 28, 2008 at 10:19:50PM +0300, Andrey Borzenkov wrote:
> I am running PCMCIA based orinoco with WPA support (external firmware)
> and two patches to cache it after request_firmware to use in resume.
> 
> This worked fine in 27 and wtopped working in 28-rc. The apparent difference
> I see:

Hm, can't find any suspect patch which would change this behaviour in PCMCIA
land. Could you try to bisect it on {drivers/base/ kernel/power
drivers/pcmcia drivers/net/wireless/orinoco*.c} possibly?

Best,
	Dominik
