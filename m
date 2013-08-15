Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:37386 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3HOXMb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 19:12:31 -0400
Received: by mail-pb0-f41.google.com with SMTP id rp2so1345557pbb.14
        for <linux-wireless@vger.kernel.org>; Thu, 15 Aug 2013 16:12:30 -0700 (PDT)
Received: from [0.0.0.0] ([210.48.94.225])
        by mx.google.com with ESMTPSA id s6sm2018942pan.12.2013.08.15.16.12.28
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Thu, 15 Aug 2013 16:12:30 -0700 (PDT)
Message-ID: <520D6058.7040405@gna.org> (sfid-20130816_011234_395319_57CE4E35)
Date: Fri, 16 Aug 2013 11:12:24 +1200
From: Christian Gagneraud <chgans@gna.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: [TL-WN721N] No disconnect notification when AP is gone
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

I'm using a TP-LINK TL-WN721N, and experience a strange behaviour, I'm 
running Ubuntu 13.04 (3.8.0-27-generic + backports-3.11-rc3-1).

The problem is that if I am connected to my AP and then power it off, I 
never receive a disconnect notification.

I first reported the bug to the connman mailing list [1], but it was 
suggested there that it could be a bug in the device driver.

At first I was using the Ubuntu kernel modules, but before reporting any 
bugs, I switched to backports-3.11-rc3-1, and I still have the problem.

Any thoughts?

Regards,
Chris

[1] Latest messages haven't been archived  yet, but:
  https://lists.connman.net/pipermail/connman/2013-August/015401.html
