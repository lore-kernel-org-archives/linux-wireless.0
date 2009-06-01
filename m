Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f168.google.com ([209.85.220.168]:37531 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753713AbZFAQV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jun 2009 12:21:56 -0400
MIME-Version: 1.0
In-Reply-To: <1243868091-5315-11-git-send-email-dbaryshkov@gmail.com>
References: <1243868091-5315-1-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-3-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-4-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-5-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-6-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-7-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-8-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-9-git-send-email-dbaryshkov@gmail.com> <1243868091-5315-10-git-send-email-dbaryshkov@gmail.com>
	<1243868091-5315-11-git-send-email-dbaryshkov@gmail.com>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Mon, 1 Jun 2009 18:21:37 +0200
Message-ID: <69e28c910906010921r56cf7017gc858cb7ba819c385@mail.gmail.com>
Subject: Re: [PATCH 10/10] ieee802154: add at86rf230/rf231 spi driver
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org, slapin@ossfans.org,
	maxim.osipov@siemens.com, dmitry.baryshkov@siemens.com,
	oliver.fendt@siemens.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 1, 2009 at 4:54 PM, Dmitry Eremin-Solenikov
<dbaryshkov@gmail.com> wrote:
> Add a driver handling AT86RF230/RF231 line of chips. Only basic
> features are currently implemented (no extended mode operation, etc.)
> Also the RF230 chip is not really supported yet.
>
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> Signed-off-by: Sergey Lapin <slapin@ossfans.org>
> ---
>  drivers/ieee802154/Kconfig     |    5 +
>  drivers/ieee802154/Makefile    |    1 +
>  drivers/ieee802154/at86rf230.c |  971 ++++++++++++++++++++++++++++++++++++++++

Shouldn't this go into drivers/net/ieee802154 instead?
