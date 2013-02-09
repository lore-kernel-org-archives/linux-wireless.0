Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36581 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932209Ab3BIAqq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 19:46:46 -0500
Received: by mail-pa0-f47.google.com with SMTP id bj3so2384650pad.34
        for <linux-wireless@vger.kernel.org>; Fri, 08 Feb 2013 16:46:46 -0800 (PST)
Date: Fri, 8 Feb 2013 16:46:44 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: Other alloc/OOM message question
Message-ID: <20130209004644.GC31290@kroah.com> (sfid-20130209_014703_126087_B463CCC4)
References: <1360273587.27863.15.camel@joe-AO722>
 <20130208.174500.1518593039138341685.davem@davemloft.net>
 <1360369799.13487.5.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360369799.13487.5.camel@joe-AO722>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 08, 2013 at 04:29:59PM -0800, Joe Perches wrote:
> On Fri, 2013-02-08 at 17:45 -0500, David Miller wrote:
> > From: Joe Perches <joe@perches.com>
> > Date: Thu, 07 Feb 2013 13:46:27 -0800
> > > alloc failures already get standardized OOM
> > > messages and a dump_stack.
> 
> Does anyone know if all the other alloc's like
> dma_alloc_coherent, dma_alloc_noncoherent,
> pci_alloc_consistent always produce OOM messages
> via page_alloc/warn_alloc_failed for all arches?

If not, they should, to allow this type of cleanups.

thanks,

greg k-h
