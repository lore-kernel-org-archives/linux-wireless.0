Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37837 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab2DWVKB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:10:01 -0400
Received: by obbta14 with SMTP id ta14so13218909obb.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 14:10:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1335131965-20280-1-git-send-email-hauke@hauke-m.de>
References: <1335131965-20280-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 23 Apr 2012 14:09:40 -0700
Message-ID: <CAB=NE6UbQgYY+KcUt1rD14vyfwJkX9mdbQVKzMPwtgHOC+LEQg@mail.gmail.com> (sfid-20120423_231018_293575_C77718DE)
Subject: Re: [PATCH 1/2] compat: add module_pci_driver
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Apr 22, 2012 at 2:59 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> module_pci_driver is needed to register the pci driver to the pci sub system.

Thanks ! I see no Signed-off-by tag on these though, I use the SOB tag
just as the kernel and other projects us it, the meaning of it is the
same, under the "Developer's Certificate of Origin 1.1":

http://gerrit.googlecode.com/svn/documentation/2.0/user-signedoffby.html

Do you SOB these patches?

  Luis
