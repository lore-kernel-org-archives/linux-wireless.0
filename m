Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f175.google.com ([209.85.215.175]:42706 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875AbaCGV2A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 16:28:00 -0500
From: Christian Lamparter <chunkeey@googlemail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] p54usb: fix leaks at failure path in p54u_probe()
Date: Fri, 07 Mar 2014 22:27:34 +0100
Message-ID: <2146611.esrnhmtufH@debian64> (sfid-20140307_222826_767944_15F03782)
In-Reply-To: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru>
References: <1394226709-10763-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday, March 08, 2014 01:11:49 AM Alexey Khoroshilov wrote:
> If p54u_load_firmware() fails, p54u_probe() does not deallocate
> already allocated resources. The patch adds proper failure handling.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>

