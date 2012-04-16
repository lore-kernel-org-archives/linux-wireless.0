Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45629 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2DPTDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 15:03:44 -0400
Received: by bkcik5 with SMTP id ik5so3936865bkc.19
        for <linux-wireless@vger.kernel.org>; Mon, 16 Apr 2012 12:03:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120416105528.GA25190@elgon.mountain>
References: <20120416105528.GA25190@elgon.mountain>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 16 Apr 2012 22:03:26 +0300
Message-ID: <CA+XVXfeZd+P135QjR1YarVq-qVvK-N1H8wMe5UaDGy+7Rb_Bpg@mail.gmail.com> (sfid-20120416_210347_834282_D9AFCF44)
Subject: Re: wlcore/wl12xx: change GEM Tx-spare blocks per-vif
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 16, 2012 at 13:55, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Arik Nemtsov,
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch 3edab305dfd4: "wlcore/wl12xx: change GEM Tx-spare blocks
> per-vif" from Dec 7, 2011, leads to the following Smatch complaint:
>
> drivers/net/wireless/ti/wlcore/tx.c:231 wl1271_tx_allocate()
>         warn: variable dereferenced before check 'wlvif' (see line 208)

Thanks Dan. We'll fix it shortly.

Arik
