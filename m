Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41283 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab1IAVlR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 17:41:17 -0400
Received: by wyh22 with SMTP id 22so1371085wyh.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Sep 2011 14:41:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAE+U-fEjMBMG53yhEExAcsBbVjAwLE4jxGUi4jsz9vLaa=hQdw@mail.gmail.com>
References: <CAE+U-fEjMBMG53yhEExAcsBbVjAwLE4jxGUi4jsz9vLaa=hQdw@mail.gmail.com>
Date: Thu, 1 Sep 2011 23:41:14 +0200
Message-ID: <CAE+U-fHTBNFkQq+-9p9uyc+Z3gEDh6a=Wubdvda7pdTXcykW6g@mail.gmail.com> (sfid-20110901_234124_722381_72C32E09)
Subject: [iwlagn] Major Bug, regression found in the 3.1 kernel series
From: alanwww1 <alanwww1@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I found a serious bug in the 3.1 kernel series. It is a major regression.
I also tested the situation with today's snapshot with the same result.
I already reported at two places, but i am not sure if it was the right place:

https://bugzilla.kernel.org/show_bug.cgi?id=41972
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/837995

Also it behaves the same if I compile the kernel myself and not use
the Ubuntu packages.
Thanks, Alan
