Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:46600 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758538Ab0EYBDA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 May 2010 21:03:00 -0400
Received: by pxi18 with SMTP id 18so1700866pxi.19
        for <linux-wireless@vger.kernel.org>; Mon, 24 May 2010 18:03:00 -0700 (PDT)
Message-ID: <4BFB21C1.3060703@gmail.com>
Date: Mon, 24 May 2010 18:02:57 -0700
From: Huy Le <lehuy0406@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ioctl for b43 driver
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Currently I try aircrack-ng with b43 driver but it is fail at this 
statement due to the following statement:

     ioctl( fd, SIOCGIWFREQ, &wrq ) < 0

This happens because we do not have ioctl for b43 driver. I just want to 
ask if there is any way to work around.

Thanks.
