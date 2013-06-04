Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:29014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751812Ab3FDNz1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 09:55:27 -0400
Date: Tue, 4 Jun 2013 15:57:19 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Gabor Juhos <juhosg@openwrt.org>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH 00/13] rt2x00: get rid of static data queue descriptors
Message-ID: <20130604135718.GC17229@redhat.com> (sfid-20130604_155541_378292_FC43CD1D)
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370346050-7047-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 04, 2013 at 01:40:37PM +0200, Gabor Juhos wrote:
> The patch-set depends on the following patch:
> 
> 'rt2x00: rt2x00queue: initialize data_queue fields earlier'
> https://patchwork.kernel.org/patch/2655201/
> 
> Gabor Juhos (13):
>   rt2x00: rt2x00queue: add priv_size field to struct data_queue
>   rt2x00: rt2x00queue: remove qdesc parameter of
>     rt2x00queue_alloc_entries
>   rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
>   rt2x00: rt2x00queue: setup queue->threshold from queue->limit
>   rt2x00: add queue_init callback to rt2x00_ops
>   rt2x00: rt2800usb: implement queue_init callback
>   rt2x00: rt2800pci: implement queue_init callback
>   rt2x00: rt73usb: implement queue_init callback
>   rt2x00: rt2400pci: implement queue_init callback
>   rt2x00: rt2500pci: implement queue_init callback
>   rt2x00: rt61pci: implement queue_init callback
>   rt2x00: rt2500usb: implement queue_init callback
>   rt2x00: remove data_queue_desc struct

Looks good. For set:

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com> 

