Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40401 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab0KGTo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 14:44:59 -0500
Received: by pvb32 with SMTP id 32so1107874pvb.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Nov 2010 11:44:59 -0800 (PST)
Message-ID: <4CD701D9.9000405@lwfinger.net>
Date: Sun, 07 Nov 2010 13:45:29 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Werner Nagel <werner.nagel@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: bug in wireless driver
References: <20101107183639.316560@gmx.net>
In-Reply-To: <20101107183639.316560@gmx.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/07/2010 12:36 PM, Werner Nagel wrote:
> I would like to send you a bug report from linux (ubunto) and wireless driver b43.
> There is the file with the kernel-log and a file with the ouput from lspci -k.
> Thank you from Germany

The code in that section was fixed nearly a year ago, but the fixes are too
intrusive to be backported to 2.6.32. If Ubuntu has a compat-wireless package,
please install it.

Larry
