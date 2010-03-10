Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13667 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755180Ab0CJDQP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 22:16:15 -0500
Subject: Re: Realtek rtl8188 support?
From: Pavel Roskin <proski@gnu.org>
To: =?ISO-8859-1?Q?G=E1bor?= Stefanik <netrolller.3d@gmail.com>
Cc: Paul Thomas <pthomas8589@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
References: <c785bba31003060945j22be2e78pfeaa1bcd39fcba2c@mail.gmail.com>
	 <69e28c911003061007y258ec349laa802810e0517de4@mail.gmail.com>
	 <1267949782.15192.13.camel@mj>
	 <69e28c911003070736t678cf6ccld0fe6dc332f4380d@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Mar 2010 22:16:13 -0500
Message-Id: <1268190973.10669.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2010-03-07 at 16:36 +0100, Gábor Stefanik wrote:

> Maybe with an actual RTL8192SU firmware it would work... just my 2 HUF.

Actually, you are absolutely right!  The driver is working fine with the
firmware from rtl8192su_linux_2.6.0002.0708.2009.tar.gz

CCMP is working, and I could browse the web over it!

-- 
Regards,
Pavel Roskin
