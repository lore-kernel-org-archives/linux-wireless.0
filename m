Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate01.web.de ([217.72.192.221]:40407 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753281AbZDZTNc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Apr 2009 15:13:32 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Roel Kluin <roel.kluin@gmail.com>
Subject: Re: [PATCH] ar9170: wrong test on outlen in ar9170_usb_exec_cmd() ?
Date: Sun, 26 Apr 2009 21:13:20 +0200
Cc: linux-wireless@vger.kernel.org
References: <49F4565B.2000201@gmail.com>
In-Reply-To: <49F4565B.2000201@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200904262113.20544.chunkeey@web.de> (sfid-20090426_211336_130781_93FB62BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 26 April 2009 14:40:59 Roel Kluin wrote:
> remove redundant test: outlen is unsigned
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Christian Lamparter <chunkeey@web.de>
> ---
> Maybe you want to test outlen < MAX, but what should MAX be?
Not necessary, there is no hard limit for the size of cmd response.
The firmware will scatter the cmd responses into ~64 bytes packages, if needed.

Regards,
	Chr
