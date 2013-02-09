Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:37492 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1947344Ab3BIAaA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 19:30:00 -0500
Message-ID: <1360369799.13487.5.camel@joe-AO722> (sfid-20130209_013234_588269_61CC5700)
Subject: Other alloc/OOM message question
From: Joe Perches <joe@perches.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Fri, 08 Feb 2013 16:29:59 -0800
In-Reply-To: <20130208.174500.1518593039138341685.davem@davemloft.net>
References: <1360273587.27863.15.camel@joe-AO722>
	 <20130208.174500.1518593039138341685.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 17:45 -0500, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Thu, 07 Feb 2013 13:46:27 -0800
> > alloc failures already get standardized OOM
> > messages and a dump_stack.

Does anyone know if all the other alloc's like
dma_alloc_coherent, dma_alloc_noncoherent,
pci_alloc_consistent always produce OOM messages
via page_alloc/warn_alloc_failed for all arches?

If so, there are many more of these OOM messages
that could be removed.


