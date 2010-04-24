Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:58058 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0DXI7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Apr 2010 04:59:23 -0400
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Maciej =?utf-8?q?=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: ath5k misbehaving affecting other kernel parts unrelated?
Date: Sat, 24 Apr 2010 09:59:16 +0100
Cc: me@bobcopeland.com, "John W. Linville" <linville@tuxdriver.com>,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	mickflemm@gmail.com
References: <201004230806.13628.pedrogfrancisco@gmail.com> <20100423163703.GB11112@hash.localnet> <v2p55a4f86e1004230943j6b312cacpca585c80096375ea@mail.gmail.com>
In-Reply-To: <v2p55a4f86e1004230943j6b312cacpca585c80096375ea@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201004240959.16688.pedrogfrancisco@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I've 2 GB RAM + 5GB swap (got fed up with hibernating not working sometimes), 
so no such errors.

A Sexta, 23 de Abril de 2010 17:43:59 Maciej Żenczykowski escreveu:
> Do you have more than ~2.5-3.5GB of ram (enough to make some ram
> non-32-bit-DMA-accessible) with swiotlb enabled,
> if such are you seeing "DMA: Out of SW-IOMMU space" kernel messages?
> 
