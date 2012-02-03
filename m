Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196Ab2BCN2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Feb 2012 08:28:07 -0500
Date: Fri, 3 Feb 2012 14:27:54 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 14/25] iwlegacy: remove ctx interface_modes
Message-ID: <20120203132753.GA2213@redhat.com> (sfid-20120203_142830_019949_4EC523B7)
References: <1328270845-16891-1-git-send-email-sgruszka@redhat.com>
 <1328270845-16891-15-git-send-email-sgruszka@redhat.com>
 <0B65A226-873C-4228-BA58-659B93E25564@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <0B65A226-873C-4228-BA58-659B93E25564@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 03, 2012 at 01:47:10PM +0100, Gertjan van Wingerde wrote:
> On 3 feb. 2012, at 13:07, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> 
> > Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
> > ---
> > drivers/net/wireless/iwlegacy/3945-mac.c |    6 ++----
> > drivers/net/wireless/iwlegacy/4965-mac.c |    6 ++----
> > drivers/net/wireless/iwlegacy/common.c   |   29 ++++-------------------------
> > drivers/net/wireless/iwlegacy/common.h   |    2 --
> > drivers/net/wireless/rt2x00/rt2800usb.c  |   16 ++--------------
> > 5 files changed, 10 insertions(+), 49 deletions(-)
> > 
> 
> There's a change to rt2800usb here that doesn't belong here.

Thank you very much Gertjan! I guess I should not work on many things
at once ...
