Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from danu.mythicnet.org ([69.36.14.47]:53832 "EHLO
	danu.mythicnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752924Ab1ATNvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 08:51:11 -0500
Received: from localhost (localhost [127.0.0.1])
	by danu.mythicnet.org (Postfix) with SMTP id 2CF6678350
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 08:51:10 -0500 (EST)
Received: from OITR8LWLVZ (dhcp-125-069.cns.ohiou.edu [132.235.125.69])
	by danu.mythicnet.org (Postfix) with ESMTPSA id E04147832A
	for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 08:51:09 -0500 (EST)
From: "Ilya Kogan" <ikogan@mythicnet.org>
To: <linux-wireless@vger.kernel.org>
References: <4D334D00.4030604@mythicnet.org> <4D3521FD.9020001@mythicnet.org>,<loom.20110120T120235-29@post.gmane.org> <400C43189542CE41BC0A5B252FC90136952F059551@SJEXCHCCR02.corp.ad.broadcom.com>
In-Reply-To: <400C43189542CE41BC0A5B252FC90136952F059551@SJEXCHCCR02.corp.ad.broadcom.com>
Subject: RE: [PATCH] Kernel Panic on Associate with brcm80211.
Date: Thu, 20 Jan 2011 08:51:07 -0500
Message-ID: <000001cbb8a9$181f4f40$485dedc0$@mythicnet.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey,

> I posted an official patch (removing the assert) to the staging repository
as 
> I did run into this same issue. It will take some time before it is
propagated. 
> As this is a staging driver patches are to be sent to
devel@linuxdriverproject.org 
> (see http://driverdev.linuxdriverproject.org/pipermail/devel/).

Thanks very much, guess I'm not as crazy as I thought. I'm seeing a lot more
of the 
AC_BE txop exceeded phylen errors. For some reason, I cannot maintain TCP 
connections either. I haven't had a chance to wireshark the behavior, but
even if
I'm not doing a lot of data transfers, my connections will die randomly with
no indications
as to why. I don't lose my AP association and nothing gets reinitialized.
I'm not sure if
this problem is related to the errors as they don't reliably happen around
when the
connections give out. By the way, in case there's any question, I've
confirmed that the
card works correctly on Windows.

Thanks,
-- Ilya Kogan


