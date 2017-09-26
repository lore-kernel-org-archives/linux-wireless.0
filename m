Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53356 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935625AbdIZPIj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 11:08:39 -0400
Message-ID: <1506438516.22427.21.camel@sipsolutions.net> (sfid-20170926_171007_460437_FB1538F7)
Subject: Re: [PATCH] p54: don't unregister leds when they are inited
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrey Konovalov <andreyknvl@google.com>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Date: Tue, 26 Sep 2017 17:08:36 +0200
In-Reply-To: <384966f3a79915b4617d808c40e63072aa8b868d.1506438160.git.andreyknvl@google.com> (sfid-20170926_170718_298486_4DFAC802)
References: <384966f3a79915b4617d808c40e63072aa8b868d.1506438160.git.andreyknvl@google.com>
         (sfid-20170926_170718_298486_4DFAC802)
Content-Type: text/plain
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject should say *not* initialized?

johannes
