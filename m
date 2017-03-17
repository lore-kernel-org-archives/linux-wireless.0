Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f48.google.com ([74.125.83.48]:35220 "EHLO
        mail-pg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdCQFsK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Mar 2017 01:48:10 -0400
Received: by mail-pg0-f48.google.com with SMTP id b129so35897226pgc.2
        for <linux-wireless@vger.kernel.org>; Thu, 16 Mar 2017 22:47:51 -0700 (PDT)
Received: from xeon-e3 (204-195-18-65.wavecable.com. [204.195.18.65])
        by smtp.gmail.com with ESMTPSA id u29sm7804856pfa.123.2017.03.16.22.47.50
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 16 Mar 2017 22:47:50 -0700 (PDT)
Date: Thu, 16 Mar 2017 22:47:43 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: linux-wireless@vger.kernel.org
Subject: Fw: [Bug 194903] New: After updating Kernel to 4.9.9 my wireless
 adapter does not work
Message-ID: <20170316224743.2723cf14@xeon-e3> (sfid-20170317_064859_645514_38F617B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



Begin forwarded message:

Date: Fri, 17 Mar 2017 02:22:58 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 194903] New: After updating Kernel to 4.9.9 my wireless adapter does not work


https://bugzilla.kernel.org/show_bug.cgi?id=194903

            Bug ID: 194903
           Summary: After updating Kernel to 4.9.9 my wireless adapter
                    does not work
           Product: Networking
           Version: 2.5
    Kernel Version: 4.9.9
          Hardware: x86-64
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: blocking
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: jemel.robinson@icloud.com
        Regression: No

I have a Macbook Pro 13" (7, 1) and when I updated my kernel version to 4.9.9
(F25), my broadcom wireless adapter is no longer detected. I have since updated
to the latest kernel and have gotten the same result. As of now, I am currently
operating at the kernel version prior to 4.9.9 (4.8.6-300.fc25.x86_64
) and I am able to use WiFi with no issues. I have tried uninstalling and
reinstalling the broadcom -wl driver to no avail. I narrowed the issue down to
the kernel simply by updating the kernel only and after reboot, wireless was
gone.

-- 
You are receiving this mail because:
You are the assignee for the bug.
