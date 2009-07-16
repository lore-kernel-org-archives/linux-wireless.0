Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:43258 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932941AbZGPTEM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jul 2009 15:04:12 -0400
Received: by yxe14 with SMTP id 14so547261yxe.33
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2009 12:04:11 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 16 Jul 2009 15:04:11 -0400
Message-ID: <9e4733910907161204x441c21b9n22530800682d363@mail.gmail.com>
Subject: Cross compiling crda and SSL word size
From: Jon Smirl <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When cross compiling crda the Makefile asks the python system what the
word size is. This gets the word size from the host. Is there a way to
ask the word size using gcc? In my environment the Makefile is
automatically using the correct gcc cross compiler.

My host is 64b and target is 32b.

-- 
Jon Smirl
jonsmirl@gmail.com
