Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:46545 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYKYPfs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 10:35:48 -0500
Received: by rv-out-0506.google.com with SMTP id k40so7942rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 07:35:47 -0800 (PST)
Message-ID: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com> (sfid-20081125_163552_870874_3035F6C6)
Date: Tue, 25 Nov 2008 17:35:47 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: AP (Master Mode) of wireless drivers
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

According to the linux wireless wiki, only four Linux drivers support
AP (Master Mode) ; these
are  b43/b43legacy (Broadcom chips), Intel ipw2200, and
libertas_tf and p54 (Intersil chips).
see:
http://www.linuxwireless.org/en/users/Drivers

My question is: is this information updated ?

More specifically, I am particularly interested to know whether Intel
iwl3945 and Intel iwl4965 support AP (Master Mode), and in case they
do not (as I am afraid is the situation)
- is there any intention to add AP (masted mode) support to these drivers
in the near future ?

Regards,
Mark
