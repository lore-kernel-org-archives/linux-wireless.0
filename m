Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f54.google.com ([209.85.214.54]:37773 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538Ab3CXMrG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Mar 2013 08:47:06 -0400
Received: by mail-bk0-f54.google.com with SMTP id q16so84729bkw.27
        for <linux-wireless@vger.kernel.org>; Sun, 24 Mar 2013 05:47:04 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Marco Fonseca <marco@tampabay.rr.com>
Subject: Re: carl9170: monitor mode hangs due to channel changes
Date: Sun, 24 Mar 2013 13:46:59 +0100
Cc: linux-wireless@vger.kernel.org
References: <20130320205013.GA3462@192.168.1.10> <201303202309.47596.chunkeey@googlemail.com> <20130323200037.GA8332@192.168.1.10>
In-Reply-To: <20130323200037.GA8332@192.168.1.10>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201303241347.00115.chunkeey@googlemail.com> (sfid-20130324_134717_602338_87184FE3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 23 March 2013 21:00:38 you wrote:
> As far as I can tell those patches fixed it.  I wasn't paying
> attention and applied both patches though.  My environment is
> a little different today and I will test some more on Monday.
No worries. I can wait for the test results on Monday.
 
> If you think it would help, I can test the patches individually.
Yes. The second patch disables the "fast channel change" feature.
And this should be avoided, unless of course it is absolutely
necessary.

Regards,
	Chr
