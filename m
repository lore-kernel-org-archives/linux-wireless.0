Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.249]:23408 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992AbXGGDXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2007 23:23:48 -0400
Received: by an-out-0708.google.com with SMTP id d31so83264and
        for <linux-wireless@vger.kernel.org>; Fri, 06 Jul 2007 20:23:47 -0700 (PDT)
Message-ID: <45b4f7d90707062023i25dfb913s3e22b404490f245c@mail.gmail.com>
Date: Fri, 6 Jul 2007 22:23:46 -0500
From: "Benjamin Bryant" <blbryant@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: problem installing mac80211 on Fedora Core 7
In-Reply-To: <45b4f7d90707062022j384934a1neb431bad641ef5b1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
References: <45b4f7d90707062022j384934a1neb431bad641ef5b1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm getting the following output:

# make patch_kernel
Patching from compatible/ to /lib/modules/2.6.21-1.3228.fc7/source/:
 + Replaced 57 files.
Checking for required kernel build updates...
 - checking net/Kconfig and net/Makefile...
 - checking net/core/Makefile for old 'wireless'...
 - checking net/core/dev.c for wireless_proc_init vs. wext_proc_init...
grep: /lib/modules/2.6.21-1.3228.fc7/source/net/core/dev.c: No such
file or directory
 - checking net/core/dev.c for wireless_process_ioctl v. wext_handle_ioctl...
grep: /lib/modules/2.6.21-1.3228.fc7/source/net/core/dev.c: No such
file or directory
 - checking net/core/dev.c for linxu/wireless.h v. net/wext.h...
grep: /lib/modules/2.6.21-1.3228.fc7/source/net/core/dev.c: No such
file or directory
 - checking net/core/dev.c for wireless_proc_init vs. wext_proc_init...
grep: /lib/modules/2.6.21-1.3228.fc7/source/net/core/dev.c: No such
file or directory
 - checking net/Makefile and Kconfig for old 'd80211'...
Done.

What am I missing?

Ben
