Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:38112 "EHLO
        mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdCPOXp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Mar 2017 10:23:45 -0400
Received: by mail-wm0-f41.google.com with SMTP id t189so49226137wmt.1
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 07:21:57 -0700 (PDT)
To: ilw@linux.intel.com
Cc: linux-wireless@vger.kernel.org
From: korgman <korgie@gmail.com>
Subject: iwl3945 bug report (occasionally crashing after suspend)
Message-ID: <7ae0bf4f-6ea2-1a4c-2e6d-e793cf800c4a@gmail.com> (sfid-20170316_152348_984864_6B6A2309)
Date: Thu, 16 Mar 2017 16:26:10 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello there,

I have the same problem as reported here.
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1627828

and here
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1629603

If I understood correctly (form 2nd link) the latest good kernel was 4.4.4 after 4.4.6 we have the problem. (see message #5)

I quote:
"Not a full bisection yet but I have narrowed it down:

I looked at all kernel versions that had changes committed to iwlwifi and tested between them.

I now have determined that I do not have this issue in the kernel version 4.4.4.

I do have the issue in 4.4.6 and that is the next kernel version that has changes to iwlwifi so I guess that is the first bad version."

I am on Slackware-14.2 64bit custom config kernel. I can try some things if you want.

If I modprobe -r iwl3945 | disable wifi (i have physical switch) | suspend to ram | power on | enable wifi (physical switch) | modrpobe iwl3945 the device is working again.

Thank you!

(excuse my bad English)
