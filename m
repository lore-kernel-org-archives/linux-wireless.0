Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:33679 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757103Ab0EYChT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 22:37:19 -0400
Received: by pxi18 with SMTP id 18so1733316pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 19:37:18 -0700 (PDT)
Message-ID: <4BFB37DD.1080002@gmail.com>
Date: Mon, 24 May 2010 19:37:17 -0700
From: Huy Le <lehuy0406@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ioctl with b43 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am trying aircrack-ng and I found in the source of aircrack-ng that they called ioctl( fd, SIOCGIWFREQ,&wrq ). But the driver of b43 doesn't supportioctl, so this call is failed. Is there any solution for me?

My wireless card is BCM4312 [14e4:4315]

Thanks.

