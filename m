Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:34493 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754415AbbFBS35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 14:29:57 -0400
Received: by ieczm2 with SMTP id zm2so139802116iec.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Jun 2015 11:29:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1433194803.3505.19.camel@sipsolutions.net>
References: <1390373865-6088-1-git-send-email-chaitanya.mgit@gmail.com>
 <1390426022.4334.50.camel@jlt4.sipsolutions.net> <CABPxzYK3pBK4QQh2W_vZbggkfszx+9d-zH+QC_uOXzDxfUMbUQ@mail.gmail.com>
 <CABPxzYLW955-jJHKHYT+P0U8RM=GWajpCYDa8L-XtjCN71U0kw@mail.gmail.com>
 <1433191009.3505.18.camel@sipsolutions.net> <CABPxzY+eaUB6BY-c71RPxqSThizCM=qzt=K_+4du8zHLrY=_oQ@mail.gmail.com>
 <1433194803.3505.19.camel@sipsolutions.net>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Tue, 2 Jun 2015 23:59:36 +0530
Message-ID: <CABPxzYJJvdekO0k=i+GBt+rgvfwW-2P3rRix370hfgmWqpurmw@mail.gmail.com> (sfid-20150602_203000_444728_E836ADAF)
Subject: Re: [PATCH] minstrel_ht: Use RTS_CTS when STA is in DYNAMIC SMPS mode
 for frames sent using Nss>1.
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Felix Fietkau <nbd@openwrt.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 2, 2015 at 3:10 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2015-06-02 at 03:03 +0530, Krishna Chaitanya wrote:
>
>> > This patch is *ancient*, before we actually used patchwork properly ...
>> Ok, so you want me to send a V2 with the indentation fixed?
>> (or) shall i wait for Felix's review before sending V2?
>
> It seems unlikely that anyone would want to review a patch over 15
> months later :)

 Please drop this patch, i have sent a new one in sync with HEAD.

-- 
Thanks,
Regards,
Chaitanya T K.
