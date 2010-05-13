Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.157]:36443 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab0EMTb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 May 2010 15:31:56 -0400
Received: by fg-out-1718.google.com with SMTP id d23so1288672fga.1
        for <linux-wireless@vger.kernel.org>; Thu, 13 May 2010 12:31:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1273778166-3833-4-git-send-email-gwingerde@gmail.com>
References: <1273778166-3833-1-git-send-email-gwingerde@gmail.com>
	 <1273778166-3833-4-git-send-email-gwingerde@gmail.com>
Date: Thu, 13 May 2010 21:31:53 +0200
Message-ID: <AANLkTilL-kLBbCuNikCclWyqlkDZsHzI3QKEuBgtt4ra@mail.gmail.com>
Subject: Re: [PATCH 3/4] rt2x00: Clean up USB vendor request buffer functions.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Gertjan van Wingerde <gwingerde@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 13, 2010 at 9:16 PM, Gertjan van Wingerde
<gwingerde@gmail.com> wrote:
> There is no need to force the separation between a buffer USB vendor
> request that does fit the CSR cache and one that doesn't onto the
> callers. This is something that the rt2x00usb_vendor_request_buff
> function can figure out by itself.
> Combine the rt2x00usb_vendor_request_buff and
> rt2x00usb_vendor_request_large_buff functions into a single one, as
> both of them were equivalent for small buffers anyway.
>
> Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>

Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
