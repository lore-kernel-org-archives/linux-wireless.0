Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:61499 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab2DNKcY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 Apr 2012 06:32:24 -0400
Date: Sat, 14 Apr 2012 12:32:18 +0200
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: netdev@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Simon Kelley <simon@thekelleys.org.uk>,
	Jouni Malinen <j@w1.fi>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] net/wireless: use module_pci_driver
Message-ID: <20120414103218.GF28523@wantstofly.org> (sfid-20120414_123234_142168_3C91B696)
References: <1334371116.17649.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334371116.17649.1.camel@phoenix>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Apr 14, 2012 at 10:38:36AM +0800, Axel Lin wrote:

> This patch converts the drivers in drivers/net/wireless/* to use
> module_pci_driver() macro which makes the code smaller and a bit simpler.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Cc: "John W. Linville" <linville@tuxdriver.com>
> Cc: Jiri Slaby <jirislaby@gmail.com>
> Cc: Nick Kossifidis <mickflemm@gmail.com>
> Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
> Cc: Simon Kelley <simon@thekelleys.org.uk>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Lennert Buytenhek <buytenh@wantstofly.org>
> Cc: Christian Lamparter <chunkeey@googlemail.com>
> Cc: Ivo van Doorn <IvDoorn@gmail.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Cc: linux-wireless@vger.kernel.org

Acked-by: Lennert Buytenhek <buytenh@wantstofly.org>
