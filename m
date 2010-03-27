Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f209.google.com ([209.85.218.209]:36157 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0C0MWP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Mar 2010 08:22:15 -0400
Received: by bwz1 with SMTP id 1so2442680bwz.21
        for <linux-wireless@vger.kernel.org>; Sat, 27 Mar 2010 05:22:14 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Valentin Longchamp <valentin.longchamp@epfl.ch>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] setup correct int pipe type in ar9170_usb_exec_cmd
Date: Sat, 27 Mar 2010 13:22:09 +0100
References: <1269600273-7974-1-git-send-email-valentin.longchamp@epfl.ch>
In-Reply-To: <1269600273-7974-1-git-send-email-valentin.longchamp@epfl.ch>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <201003271322.09470.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 March 2010 11:44:33 Valentin Longchamp wrote:
> An int urb is constructed but we fill it in with a bulk pipe type.
> 
> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 implemented a pipe type
> check when CONFIG_USB_DEBUG is enabled. The check failed for all the ar9170
> usb transfers and the driver could not configure the wifi dongle.
> 
> This went unnoticed until now because most people don't have
> CONFIG_USB_DEBUG enabled.
> 
> Signed-off-by: Valentin Longchamp <valentin.longchamp@epfl.ch>
> ---
Cc: Stable <stable@kernel.org>
Acked-by: Christian Lamparter <chunkeey@googlemail.com>
