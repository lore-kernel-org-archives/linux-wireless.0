Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:5005 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbaFMNM2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jun 2014 09:12:28 -0400
Date: Fri, 13 Jun 2014 15:10:35 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michael Braun <michael-dev@fami-braun.de>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	netdev@vger.kernel.org, users@rt2x00.serialmonkey.com,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] rt2800usb:fix hang during firmware load
Message-ID: <20140613131035.GC2211@redhat.com> (sfid-20140613_151246_941142_3FFAE42B)
References: <20140612173057.15935.14194.stgit@charlie.fem.tu-ilmenau.de>
 <20140612173341.15935.7058.stgit@charlie.fem.tu-ilmenau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140612173341.15935.7058.stgit@charlie.fem.tu-ilmenau.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 12, 2014 at 07:33:41PM +0200, Michael Braun wrote:
> The device 057c:8501 (AVM Fritz! WLAN v2 rev. B) boots into a state that does
> not actually require loading a firmware file. The vendors driver finds out
> about this by checking a firmware state register, so this patch adds this here.
> 
> Finally, with this patch applied, my wifi dongle actually becomes
> useful (scan + connect to wpa network works).
> 
> Signed-off-by: Michael Braun <michael-dev@fami-braun.de>
Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
