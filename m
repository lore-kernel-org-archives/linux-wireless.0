Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37056 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932744Ab1JNNVR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 09:21:17 -0400
Received: by wyg36 with SMTP id 36so62283wyg.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Oct 2011 06:21:16 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 14 Oct 2011 15:21:16 +0200
Message-ID: <CACna6ryphLSrh5vtOEDXek7s9DGxWKSSgQB-KJVLyzfmBCP3KA@mail.gmail.com> (sfid-20111014_152122_838933_D51887D0)
Subject: How to create library module with callbacks?
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I want to create module library, which will handle PHY operations on
Broadcom card. For most of the time, I'm going to call library
functions from b43.

However, there are places where I need to call some (b43) driver
function from library module.

How can I handle that? Should I pass some functions pointers to the
library? Is that going to work? Or is there a better approach?

P.S.
I'm asking at linux-wireless, it's not wireless related however. I
think question is quite simple for C hackers and there is no need to
hit LKML.

-- 
Rafał
