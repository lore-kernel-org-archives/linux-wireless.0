Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49345 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab2GJGCY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 02:02:24 -0400
Date: Tue, 10 Jul 2012 08:02:12 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
Message-ID: <20120710060211.GA2260@redhat.com> (sfid-20120710_080227_389245_08B1FBBD)
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
 <1341834647.4455.32.camel@jlt3.sipsolutions.net>
 <20120709115423.GE2438@redhat.com>
 <CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANUX_P23xv5rXynEJHm=boR_g_7YqR1ROOQki6KGv+9LR9KEkg@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 09, 2012 at 10:10:38PM +0300, Emmanuel Grumbach wrote:
> I would be glad to know on what commands this WARN_ON triggers
> though... The command name should be printed along with the WARN_ON.

REPLY_RX_PHY_CMD

Stanislaw
