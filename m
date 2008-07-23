Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hs-out-0708.google.com ([64.233.178.240]:48779 "EHLO
	hs-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407AbYGWRPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:15:06 -0400
Received: by hs-out-0708.google.com with SMTP id 4so183738hsl.5
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 10:15:05 -0700 (PDT)
Message-ID: <43e72e890807231015q4b5e88ffwf51082fcdb8bb352@mail.gmail.com> (sfid-20080723_191510_749501_A9A68A07)
Date: Wed, 23 Jul 2008 10:15:05 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Christoph Hellwig" <hch@lst.de>
Subject: Re: [PATCH] ath9: endianess fixes
Cc: linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
In-Reply-To: <20080723165518.GB30144@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080723165518.GB30144@lst.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 9:55 AM, Christoph Hellwig <hch@lst.de> wrote:
>  - in ath_beacon_alloc use a __le64 variable to store a byte swapped
>   result.  Keep printing the unshifted native variable.
>  - in ath_bar_rx add a missing le16_to_cpu for bar->control
>  - in ath_rx_tasklet add a missing cpu_to_be16 for skb->protocol
>
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Luis R. Rodriguez <lrodriguez@atheros.com>

  Luis
