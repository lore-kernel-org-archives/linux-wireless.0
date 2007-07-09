Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.224]:56489 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbXGIO7B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2007 10:59:01 -0400
Received: by nz-out-0506.google.com with SMTP id s18so690545nze
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2007 07:59:01 -0700 (PDT)
Message-ID: <9e4733910707090759v5cd20f2en1f6c4e6fc6279b3f@mail.gmail.com>
Date: Mon, 9 Jul 2007 10:59:00 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Setting channel when interface is down inconsistency
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcm43xx and rx2x00 let me set the channel before the interface is up.
zd1211 requires the interface to be up before setting the channel.

Is there a guideline for how this is supposed to work?

-- 
Jon Smirl
jonsmirl@gmail.com
