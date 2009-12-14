Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:56638 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755229AbZLNVeg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 16:34:36 -0500
Received: by ey-out-2122.google.com with SMTP id d26so973149eyd.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Dec 2009 13:34:34 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH v2 2.6.33] rt2x00: Disable powersaving for rt61pci and rt2800pci.
Date: Mon, 14 Dec 2009 22:34:31 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	users@rt2x00.serialmonkey.com, stable@kernel.org
References: <1260819235-8017-1-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1260819235-8017-1-git-send-email-gwingerde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200912142234.32204.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 14 December 2009, Gertjan van Wingerde wrote:
> We've had many reports of rt61pci failures with powersaving enabled.
> Therefore, as a stop-gap measure, disable powersaving of the rt61pci
> until we have found a proper solution.
> Also disable powersaving on rt2800pci as it most probably will show
> the same problem.
> 
> Cc: stable@kernel.org
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>

> ---
> 
> John, this is an urgent fix for 2.6.33.
> 
> v2:
> - Handled feedback from Ivo:
> 	- Only disable powersaving by default, not permanent.
> 	- Also apply to rt2800pci.
> 
> ---
>  drivers/net/wireless/rt2x00/rt2800lib.c |    6 ++++++
>  drivers/net/wireless/rt2x00/rt61pci.c   |    5 +++++
>  2 files changed, 11 insertions(+), 0 deletions(-)
> 



