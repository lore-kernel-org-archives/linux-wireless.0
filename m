Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:49542 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab3GFTpo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Jul 2013 15:45:44 -0400
Received: by mail-wi0-f179.google.com with SMTP id hj3so2940389wib.12
        for <linux-wireless@vger.kernel.org>; Sat, 06 Jul 2013 12:45:43 -0700 (PDT)
MIME-Version: 1.0
From: "Ivan A. Ivanchikov" <ivanchikoff@gmail.com>
Date: Sun, 7 Jul 2013 06:45:22 +1100
Message-ID: <CABa=m6nQsjU6gyVDAPsm14z+rD21az3mCpYFa0pS7woVhF3gyw@mail.gmail.com> (sfid-20130706_214601_523181_F9442823)
Subject: Realtek RTL8188CUS driver
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Good day, gentlemen!

I use arch linux, and have this device
http://www.trendnet.com/downloads/list_subcategory.asp?SUBTYPE_ID=1426
Driver from stock kernel cannot be used, rtl8192cu was loaded but does not work.

I downloaded https://github.com/downloads/dvdhrm/rt8192cu/rt8192cu-3.4.3.4369.20120622.tar.gz
this sources and this patch
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1030858/comments/65
and then my network works. My current kernel version is 3.9.9.

If changes can be integrated for stock kernel?

yours respectfully, Ivan
