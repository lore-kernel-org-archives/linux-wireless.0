Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:27314 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751903AbYHLV6S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2008 17:58:18 -0400
Received: by ug-out-1314.google.com with SMTP id h2so27402ugf.16
        for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2008 14:58:16 -0700 (PDT)
Message-ID: <48A20776.80302@gmail.com> (sfid-20080812_235822_757375_8DFC5A5F)
Date: Tue, 12 Aug 2008 23:58:14 +0200
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Tomas Winkler <tomasw@gmail.com>
CC: yi.zhu@intel.com, reinette.chatre@intel.com,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: iwl + iomap + readl/writel
References: <48A1F734.7040801@gmail.com>	 <1ba2fa240808121449j4c04039bu2fc9b58129dc6027@mail.gmail.com>	 <48A20686.5080402@gmail.com> <1ba2fa240808121457j33a83effo44110a0423d83f@mail.gmail.com>
In-Reply-To: <1ba2fa240808121457j33a83effo44110a0423d83f@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/12/2008 11:57 PM, Tomas Winkler wrote:
> On Wed, Aug 13, 2008 at 12:54 AM, Jiri Slaby <jirislaby@gmail.com> wrote:
>> On 08/12/2008 11:49 PM, Tomas Winkler wrote:
>>> On Tue, Aug 12, 2008 at 11:48 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>>> Hi,
>>>>
>>>> I spotted that iwl drivers use readl method on an iomap space. IIRC some
>>>> archs might return a tag instead of an address expected by readl/writel.
>>>>
>>>> I think you should either switch to ioread32/iowrite32 or to ioremap.
>>> Can you give me reading material  on this?
>> No, google will (you can even feel lucky).
> 
> I didn't ask for obvious answers :)

Sorry, I don't remember where/when this was discussed, you have to search for it.
