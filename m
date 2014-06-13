Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaFMNJz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:09:55 -0400
Date: Fri, 13 Jun 2014 15:08:17 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] rt2800usb: Fix support for USB 057c:8501
Message-ID: <20140613130816.GA2211@redhat.com> (sfid-20140613_151059_784097_3130A254)
References: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2014 at 07:33:31PM +0200, Michael Braun wrote:
> v2: fix endianness and coding style. Using rt2x00usb_register_read does not work for me.

I missed that it use USB_MULTI_READ request and you need
USB_DEVICE_MODE instead, sorry.

Stanislaw
