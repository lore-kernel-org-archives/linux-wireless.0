Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f54.google.com ([74.125.83.54]:44255 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab3FKS3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 14:29:55 -0400
Received: by mail-ee0-f54.google.com with SMTP id t10so3692503eei.13
        for <linux-wireless@vger.kernel.org>; Tue, 11 Jun 2013 11:29:54 -0700 (PDT)
References: <1370346050-7047-1-git-send-email-juhosg@openwrt.org> <20130604135718.GC17229@redhat.com>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20130604135718.GC17229@redhat.com>
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <92AE2CE1-2C38-4859-A8DA-D4B54EB04730@gmail.com> (sfid-20130611_203001_020545_3C221757)
Cc: Gabor Juhos <juhosg@openwrt.org>,
	John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 00/13] rt2x00: get rid of static data queue descriptors
Date: Tue, 11 Jun 2013 20:29:51 +0200
To: Stanislaw Gruszka <sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Sent from my iPad

On 4 jun. 2013, at 15:57, Stanislaw Gruszka <sgruszka@redhat.com> wrote:

> On Tue, Jun 04, 2013 at 01:40:37PM +0200, Gabor Juhos wrote:
>> The patch-set depends on the following patch:
>> 
>> 'rt2x00: rt2x00queue: initialize data_queue fields earlier'
>> https://patchwork.kernel.org/patch/2655201/
>> 
>> Gabor Juhos (13):
>>  rt2x00: rt2x00queue: add priv_size field to struct data_queue
>>  rt2x00: rt2x00queue: remove qdesc parameter of
>>    rt2x00queue_alloc_entries
>>  rt2x00: rt2x00dev: use rt2x00dev->bcn->limit
>>  rt2x00: rt2x00queue: setup queue->threshold from queue->limit
>>  rt2x00: add queue_init callback to rt2x00_ops
>>  rt2x00: rt2800usb: implement queue_init callback
>>  rt2x00: rt2800pci: implement queue_init callback
>>  rt2x00: rt73usb: implement queue_init callback
>>  rt2x00: rt2400pci: implement queue_init callback
>>  rt2x00: rt2500pci: implement queue_init callback
>>  rt2x00: rt61pci: implement queue_init callback
>>  rt2x00: rt2500usb: implement queue_init callback
>>  rt2x00: remove data_queue_desc struct
> 
> Looks good. For set:
> 
> Acked-by: Stanislaw Gruszka <sgruszka@redhat.com> 

Looks good to me as well. So, an

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>

from me as well for the whole series.

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
