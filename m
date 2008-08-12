Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:43533 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbYHLVyS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 17:54:18 -0400
Received: by mu-out-0910.google.com with SMTP id w8so4642264mue.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 14:54:17 -0700 (PDT)
Message-ID: <48A20686.5080402@gmail.com> (sfid-20080812_235423_192959_F9934C36)
Date: Tue, 12 Aug 2008 23:54:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iwl + iomap + readl/writel
References: <48A1F734.7040801@gmail.com> <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
In-Reply-To: <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2008 11:49 PM, Tomas Winkler wrote:
> On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> Hi,
>>
>> I spotted that iwl drivers use readl method on an iomap space. IIRC some
>> archs might return a tag instead of an address expected by readl/writel.
>>
>> I think you should either switch to ioread32/iowrite32 or to ioremap.
> 
> Can you give me reading material  on this?

No, google will (you can even feel lucky).
