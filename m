Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:36602 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbbFYBz2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2015 21:55:28 -0400
Received: by wguu7 with SMTP id u7so50091908wgu.3
        for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2015 18:55:27 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 25 Jun 2015 09:55:27 +0800
Message-ID: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com> (sfid-20150625_035531_388406_CFE119D7)
Subject: RE: [PATCH] mac80211: mesh - don't special case routing to transmitter
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Updating the path to the transmitter of a path message is optional
> according to section 13.10.8.4 of the standard. Doing so can lead to
> better performance since we can adjust the route to the transmitter based
> on the freshest possible information. However it can also cause routing
> loops with more than four or five nodes.

Do you have the test scenario on how routing loops happen in this case?

Thanks

----
Chun-Yeow
