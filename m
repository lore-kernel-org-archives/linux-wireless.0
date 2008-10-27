Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from isilmar.linta.de ([213.133.102.198]:50127 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753316AbYJ0XD3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Oct 2008 19:03:29 -0400
Date: Tue, 28 Oct 2008 00:03:27 +0100
From: Dominik Brodowski <linux@dominikbrodowski.net>
To: reinette chatre <reinette.chatre@intel.com>
Cc: Tomas Winkler <tomasw@gmail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: 2.6.28-rc regression: Can't stop Rx DMA
Message-ID: <20081027230326.GA23250@isilmar.linta.de> (sfid-20081028_000345_857009_6EF97F0A)
References: <20081018231046.GA10977@isilmar.linta.de> <1ba2fa240810181630t781468dbi23b103e656f64153@mail.gmail.com> <20081019075916.GA12904@isilmar.linta.de> <1225145468.1115.139.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225145468.1115.139.camel@rc-desk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Oct 27, 2008 at 03:11:08PM -0700, reinette chatre wrote:
> Could you please try the following patch instead of updating your ucode?

Thanks for the patch -- it doesn't work with the old uCode, unfortunately;
while the new uCode works with or without this patch.

Best,
	Dominik
