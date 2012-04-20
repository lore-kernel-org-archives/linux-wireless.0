Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:37721 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab2DTHlQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Apr 2012 03:41:16 -0400
Received: by qadc11 with SMTP id c11so162929qad.19
        for <linux-wireless@vger.kernel.org>; Fri, 20 Apr 2012 00:41:15 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 20 Apr 2012 09:41:15 +0200
Message-ID: <CAFED-j=fZjXVhLKe=eOHM-rhR7g1ZvHeSMm1jUA0bdJbk4_qWQ@mail.gmail.com> (sfid-20120420_094119_774719_E2AFC8D6)
Subject: carl9170 - monitor mode TP drop
From: Janusz Dziedzic <janusz.dziedzic@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I am using newest compat-wireless + newest-firmware.
Next I setup monitor mode + channel and run wireshark - I do that to
record TCP flow on the channel.

Before that I had TCP throughput about 30Mbit/s and after run
wireshark I see TP drop - about 3Mbit/s (after setting monitor mode).
This TP is between AP and other STA on the same channel.

Should I set/check something more to not see this TP drop?

BR
Janusz
