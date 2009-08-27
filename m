Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f195.google.com ([209.85.212.195]:55498 "EHLO
	mail-vw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbZH0DpG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 23:45:06 -0400
Received: by vws33 with SMTP id 33so593400vws.33
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 20:45:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090827023009.21926.49329.stgit@mj.roinet.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <20090827023009.21926.49329.stgit@mj.roinet.com>
Date: Wed, 26 Aug 2009 23:45:07 -0400
Message-ID: <b6c5339f0908262045i7ccf0a58odf3fc22f7d175448@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath5k: don't use PCI ID to find the chip revision
From: Bob Copeland <me@bobcopeland.com>
To: Pavel Roskin <proski@gnu.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 26, 2009 at 10:30 PM, Pavel Roskin<proski@gnu.org> wrote:
> AR5K_SREV is available even if the chip has been put to sleep.  Relying
> on the chip register allows binding non-standard PCI IDs by
>
> echo VENDOR_ID PRODUCT_ID >/sys/bus/pci/drivers/ath5k/new_id
>
> without having to specify the driver data as well.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Looks good, thanks!

Acked-by: Bob Copeland <me@bobcopeland.com>

-- 
Bob Copeland %% www.bobcopeland.com
