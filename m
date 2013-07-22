Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vb0-f47.google.com ([209.85.212.47]:47813 "EHLO
	mail-vb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3GVO0j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jul 2013 10:26:39 -0400
Received: by mail-vb0-f47.google.com with SMTP id x14so4728546vbb.20
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jul 2013 07:26:38 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 22 Jul 2013 09:26:37 -0500
Message-ID: <CAJ8GFOgqLdk3vYAQunEOJ_O6xejEDy0uFeENmpn_s1STzyvYCQ@mail.gmail.com> (sfid-20130722_162642_208449_913CE01C)
Subject: Any way to disable RTS/CTS in minstrel_ht?
From: Harshal Chhaya <harshal@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On an AR9342-based AP with several AR6102 and AR6203 clients,
minstrel_ht uses RTS/CTS more often than it seems necessary.

Is there a way to disable RTS/CTS in minstrel_ht?

I found a discussion from a couple of years back that talked about
adding an option that tells minstel_ht to really, really turn off
RTS/CTS but I can't determine if that was implemented.

Thanks,
- Harshal
