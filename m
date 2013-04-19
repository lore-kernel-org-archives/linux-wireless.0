Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f170.google.com ([209.85.223.170]:40828 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967950Ab3DSJrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Apr 2013 05:47:53 -0400
Received: by mail-ie0-f170.google.com with SMTP id at1so844359iec.15
        for <linux-wireless@vger.kernel.org>; Fri, 19 Apr 2013 02:47:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1366201848-18009-2-git-send-email-stf_xl@wp.pl>
References: <1366201848-18009-1-git-send-email-stf_xl@wp.pl>
	<1366201848-18009-2-git-send-email-stf_xl@wp.pl>
Date: Fri, 19 Apr 2013 11:47:53 +0200
Message-ID: <CAL1gcdPuU=DayDJ+qgp8OO7mSs3QRYnhGwFmQ-4xw9GynUZPmA@mail.gmail.com> (sfid-20130419_114756_958950_66045269)
Subject: Re: [rt2x00-users] [PATCH 1/2] rt2x00: provide separate information
 about TXWI & RXWI sizes
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 17, 2013 at 2:30 PM,  <stf_xl@wp.pl> wrote:
> From: Stanislaw Gruszka <stf_xl@wp.pl>
>
> On new 2800 hardware sizes of TXWI & RXIW can be different than TXD
> & RXD sizes, so we need to difference between them. Let's define
> winfo_size as size of in buffer descriptor (TXWI & RXWI), and desc_size
> of as size of additional descriptor - in separate DMA coherent buffer
> for PCI hardware (TXD & RXD) and yet another in buffer descriptor for
> USB hardware (TXINFO & RXINFO).
>
> Change is rt2x00 wild, but should affect only 2800 driver.
>
> Patch also fix beaconing for 5592usb AP mode.
>
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>


---
Gertjan
