Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59398 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935987AbdAKKAP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 05:00:15 -0500
Message-ID: <1484128809.23671.11.camel@sipsolutions.net> (sfid-20170111_110018_452809_56E0C0E7)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
Date: Wed, 11 Jan 2017 11:00:09 +0100
In-Reply-To: <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com> (sfid-20170111_103823_204216_DEC62468)
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         <1484121737.23671.0.camel@sipsolutions.net>
         <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
         <1484125220.23671.1.camel@sipsolutions.net>
         <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
         (sfid-20170111_103823_204216_DEC62468)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I will call the mesh peers "STA A" and "STA B".
> 
> Both STA has one physical wireless I/F and wired I/F.

Ok.

[snip configuration]

> Then STA A or STA B crashes, not both.

Nevertheless, I don't have hardware to try to reproduce it, and I can't
see any such issues (even with real forwarding, I even just wrote a
wpa_s test for that) in hwsim.

Even a photo of the crash on the VT would help. Or maybe you can set up
netconsole on the wired interface?

johannes
