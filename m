Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:43736
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S932423AbdESB0T (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 May 2017 21:26:19 -0400
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>,
        Marek Vasut <marek.vasut@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>,
        linux-mtd@lists.infradead.org,
        Alessandro Zummo <a.zummo@towertech.it>,
        dri-devel@lists.freedesktop.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        linux-pwm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, kvm@vger.kernel.org,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        kpreempt-tech@lists.sourceforge.net,
        Darren Hart <dvhart@infradead.org>, rtc-linux@googlegroups.com,
        linux-gpio@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Robert Love <rml@tech9.net>,
        Kirti Wankhede <kwankhede@nvidia.com>,
        Gustavo Padovan <gustavo@padovan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        linux-wireless@vger.kernel.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-video@atrey.karlin.mff.cuni.cz,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: [PATCH 00/29] Standardize doc formats - part 3
Date: Thu, 18 May 2017 22:25:44 -0300
Message-Id: <cover.1495157082.git.mchehab@s-opensource.com> (sfid-20170519_033610_920775_667F1CCA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Each document under Documentation/*.txt has its own format.
Some follow markup notations, some don't even have a title!

In order to try to get some order on it, change the document
style to the standard we're adopting after the adoption of
ReStructured Text.

The documents touched on this series now build fine with
Sphinx, if renamed to *.rst extension.

The main goal with this is to teach people by example about
what format is expected on newer documents. It also helps
to add those files to Kernel books.

In order to make things more palatable, I'm spliting the
conversion into three parts.

This is	part 3.

Mauro Carvalho Chehab (29):
  pinctrl.txt: standardize document format
  pnp.txt: standardize document format
  preempt-locking.txt: standardize document format
  printk-formats.txt: standardize document format
  pwm.txt: standardize document format
  rbtree.txt: standardize document format
  remoteproc.txt: standardize document format
  rfkill.txt: standardize document format
  robust-futex-ABI.txt: standardize document format
  robust-futexes.txt: standardize document format
  rpmsg.txt: standardize document format
  rtc.txt: standardize document format
  SAK.txt: standardize document format
  sgi-ioc4.txt: standardize document format
  siphash.txt: standardize document format
  SM501.txt: standardize document format
  smsc_ece1099.txt: standardize document format
  static-keys.txt: standardize document format
  svga.txt: standardize document format
  sync_file.txt: standardize document format
  this_cpu_ops.txt: standardize document format
  unaligned-memory-access.txt: standardize document format
  vfio-mediated-device.txt: standardize document format
  vfio.txt: standardize document format
  video-output.txt: standardize document format
  xillybus.txt: standardize document format
  xz.txt: standardize document format
  zorro.txt: standardize document format
  dell_rbu.txt: standardize document format

 Documentation/SAK.txt                     |   65 +-
 Documentation/SM501.txt                   |    9 +-
 Documentation/dell_rbu.txt                |   81 ++-
 Documentation/pinctrl.txt                 | 1104 +++++++++++++++--------------
 Documentation/pnp.txt                     |  343 +++++----
 Documentation/preempt-locking.txt         |   40 +-
 Documentation/printk-formats.txt          |  416 ++++++-----
 Documentation/pwm.txt                     |   46 +-
 Documentation/rbtree.txt                  |   88 +--
 Documentation/remoteproc.txt              |  320 +++++----
 Documentation/rfkill.txt                  |   47 +-
 Documentation/robust-futex-ABI.txt        |   14 +-
 Documentation/robust-futexes.txt          |   12 +-
 Documentation/rpmsg.txt                   |  340 +++++----
 Documentation/rtc.txt                     |   44 +-
 Documentation/sgi-ioc4.txt                |    4 +
 Documentation/siphash.txt                 |  186 ++---
 Documentation/smsc_ece1099.txt            |    4 +
 Documentation/static-keys.txt             |  199 +++---
 Documentation/svga.txt                    |  146 ++--
 Documentation/sync_file.txt               |   23 +-
 Documentation/this_cpu_ops.txt            |   49 +-
 Documentation/unaligned-memory-access.txt |   57 +-
 Documentation/vfio-mediated-device.txt    |  252 +++----
 Documentation/vfio.txt                    |  261 +++----
 Documentation/video-output.txt            |   54 +-
 Documentation/xillybus.txt                |   29 +-
 Documentation/xz.txt                      |  182 ++---
 Documentation/zorro.txt                   |   59 +-
 29 files changed, 2437 insertions(+), 2037 deletions(-)

-- 
2.9.4
