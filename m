Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f194.google.com ([209.85.222.194]:43025 "EHLO
	mail-pz0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758195Ab0DWQoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Apr 2010 12:44:00 -0400
MIME-Version: 1.0
In-Reply-To: <20100423163703.GB11112@hash.localnet>
References: <201004230806.13628.pedrogfrancisco@gmail.com>
	 <20100423134823.GB5004@tuxdriver.com>
	 <20100423163703.GB11112@hash.localnet>
Date: Fri, 23 Apr 2010 09:43:59 -0700
Message-ID: <v2p55a4f86e1004230943j6b312cacpca585c80096375ea@mail.gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: me@bobcopeland.com
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Pedro Francisco <pedrogfrancisco@gmail.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Do you have more than ~2.5-3.5GB of ram (enough to make some ram
non-32-bit-DMA-accessible) with swiotlb enabled,
if such are you seeing "DMA: Out of SW-IOMMU space" kernel messages?

On Fri, Apr 23, 2010 at 09:37,  <me@bobcopeland.com> wrote:
> On Fri, Apr 23, 2010 at 09:48:23AM -0400, John W. Linville wrote:
>> > a) is it "normal"? I thought modules were somewhat isolated these days.
>> > b) any advices for debugging? I've yet to have two oopses that are similar....
>
> Advice for debugging: turn on slub/slab debug options, and possibly
> kmemcheck.  kmemcheck was very helpful for me last time I had such
> a corruption issue.
>
> --
> Bob Copeland %% www.bobcopeland.com
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
