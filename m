Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out30.alice.it ([85.33.2.30]:4624 "EHLO
	smtp-out30.alice.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0BHVHB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Feb 2010 16:07:01 -0500
Message-ID: <4B707A6E.2090500@iperbole.bo.it>
Date: Mon, 08 Feb 2010 21:56:14 +0100
From: Lorenzo Raschi <ded1549@iperbole.bo.it>
MIME-Version: 1.0
To: Jens Westemeier <Jens_Westemeier@web.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: p54pci: "device does not respond!"
References: <4B6F15D1.3050307@iperbole.bo.it> <201002082004.20641.Jens_Westemeier@web.de>
In-Reply-To: <201002082004.20641.Jens_Westemeier@web.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 08/02/2010 20:04, Jens Westemeier ha scritto:

>> Because I saw prism54 is deprecated now, I'm trying to switch to p54pci
>> + softmac driver. Unfortunately it doesn't work.
> Same problem with my fullmac SMC 2802 card. /var/log/messages gives:
> lspci gives:
> Network controller: Intersil Corporation ISL3890 [Prism GT/Prism
> Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

Sorry, I forgot to write my lspci's output.
Anyway, it's exactly the same as yours.

07:0e.0 Network controller: Intersil Corporation ISL3890 [Prism GT/Prism 
Duette]/ISL3886 [Prism Javelin/Prism Xbow] (rev 01)

Best regards,

Lorenzo Raschi

