Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49442 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315Ab3ETVMi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 May 2013 17:12:38 -0400
Received: by mail-bk0-f44.google.com with SMTP id jk14so2110266bkc.3
        for <linux-wireless@vger.kernel.org>; Mon, 20 May 2013 14:12:37 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 20 May 2013 17:12:37 -0400
Message-ID: <CAKb7UvhBS6G=1Burf6MfekEnT5vhiy8BKijJ27Fpd=9yBDy9Ng@mail.gmail.com> (sfid-20130520_231244_289559_C8DD3342)
Subject: iwlwifi dmar errors in 3.9.2
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I recently upgraded to 3.9.2 from 3.7.10, and have begun to see some
DMAR errors in my log. Here are a bunch of them:
http://pastebin.com/wgq0JW0S

This does not seem to negatively affect wifi -- it seems to work just
fine without any extra cajoling, but thought this might be worth
reporting. I also don't know exactly what's triggering the issue.
Hopefully the logs provide the necessary info though.

# lspci -nn -s 03:00.0
03:00.0 Network controller [0280]: Intel Corporation Centrino
Ultimate-N 6300 [8086:4238] (rev 3e)

The machine is a Thinkpad T420s. I've only recently enabled VT-d (and
thus IOMMU), which is perhaps why these didn't happen before... not
sure of the exact timing vs the kernel upgrade.

Let me know if there's any additional info you'd like to get from me.

Thanks,

  -ilia
