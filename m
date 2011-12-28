Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34195 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754418Ab1L1VBa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Dec 2011 16:01:30 -0500
Received: by obcwo16 with SMTP id wo16so8650967obc.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Dec 2011 13:01:30 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 28 Dec 2011 16:01:29 -0500
Message-ID: <CADGLRPkBk+FhPSoEf=dK+W+yx1FS0HP3tkjv6BxPHQ5ZmCRg-A@mail.gmail.com> (sfid-20111228_220134_049097_4E0B8017)
Subject: AR6002 support in ath6kl driver
From: Daniel Smith <viscous.liquid@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Greetings,

So I have recently been asked to begin supporting an AR6002 platform.
Currently it is using the Atheros ar6000 (v 2.1.2) driver. I see that
the ar6kl driver only supports the AR6003 and was wondering if there
was some technical reason that support for the AR6002 was dropped in
the up-streaming process? If not, would AR6002 support be welcomed in
the mainstream driver should I decide to attempt the endeavor of
porting/adding into the ath6kl driver? Finally, could I expect any
support from the ath6kl developers troubleshooting issues that would
inevitable arise along the way?

V/r,
Daniel Smith
