Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:51482 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139AbZL1BmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2009 20:42:17 -0500
Subject: Re: [PATCH] libertas: Remove carrier signaling from the scan code
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Holger Schurig <holgerschurig@gmail.com>
In-Reply-To: <1261212074.23392.10.camel@localhost.localdomain>
References: <20091218103649.GA3568@sortiz.org>
	 <1261212074.23392.10.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 27 Dec 2009 17:41:33 -0800
Message-ID: <1261964494.16627.92.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi John,

> > There is no reason to signal a carrier off when doing a 802.11 scan.
> > 
> > Cc: Dan Williams <dcbw@redhat.com>
> > Cc: Holger Schurig <holgerschurig@gmail.com>
> > Signed-off-by: Samuel Ortiz <sameo@linux.intel.com>
> 
> Acked-by: Dan Williams <dcbw@redhat.com>

can we get this driver merged since no wireless driver should play with
carrier on/off settings during scanning.

I would actually go that far that we should fix it in 2.6.33 and also
backport it to -stable.

Regards

Marcel


