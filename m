Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35199 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2JLHMB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 03:12:01 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Pontus Fuchs <pontus.fuchs@gmail.com>,
	linux-wireless@vger.kernel.org, hch@lst.de, s.L-H@gmx.de,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 0/4] Driver for the ar5523 chipset
References: <1349985702-21322-1-git-send-email-pontus.fuchs@gmail.com>
	<20121011203112.GB3317@kroah.com>
Date: Fri, 12 Oct 2012 10:11:57 +0300
In-Reply-To: <20121011203112.GB3317@kroah.com> (Greg KH's message of "Fri, 12
	Oct 2012 05:31:12 +0900")
Message-ID: <87haq017wi.fsf@purkki.adurom.net> (sfid-20121012_091207_286353_17A6085E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greg KH <gregkh@linuxfoundation.org> writes:

> Very nice.

Indeed.

> But what is keeping this driver from going to the "proper" place in the
> kernel tree (i.e. drivers/net/...)?  I don't have a problem adding it to
> the staging tree, but it would need a TODO file to list what is needed
> to get it out of the staging tree.

I did a really quick 5 min review of this driver and IMHO this should go
directly to drivers/net/wireless/ (or maybe to drivers/net/wireless/ath,
Luis?), I don't see any reason why this should go to staging. The code
looks clean and is only 2 kLOC. But I'll review this better during the
weekend and also run some build tests.

-- 
Kalle Valo
