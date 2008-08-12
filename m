Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.232]:25726 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbYHLV5F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 17:57:05 -0400
Received: by rv-out-0506.google.com with SMTP id k40so2990714rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 14:57:05 -0700 (PDT)
Message-ID: <1ba2fa240808121457j33a83effo44110a0423d83f@mail.gmail.com> (sfid-20080812_235712_272044_BA3D3D9C)
Date: Wed, 13 Aug 2008 00:57:05 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: iwl + iomap + readl/writel
Cc: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <48A20686.5080402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48A1F734.7040801@gmail.com>
	 <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>
	 <48A20686.5080402@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 13, 2008 at 12:54 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
> On 08/12/2008 11:49 PM, Tomas Winkler wrote:
>>
>> On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>
>>> Hi,
>>>
>>> I spotted that iwl drivers use readl method on an iomap space. IIRC some
>>> archs might return a tag instead of an address expected by readl/writel.
>>>
>>> I think you should either switch to ioread32/iowrite32 or to ioremap.
>>
>> Can you give me reading material  on this?
>
> No, google will (you can even feel lucky).

I didn't ask for obvious answers :)

Tomas
>
