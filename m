Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:59784 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932802AbdAKLCE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jan 2017 06:02:04 -0500
Message-ID: <1484132519.23671.12.camel@sipsolutions.net> (sfid-20170111_120208_497654_055C974A)
Subject: Re: [REGRESSION, bisect] mesh: SAE connection causes kernel crash
From: Johannes Berg <johannes@sipsolutions.net>
To: Masashi Honma <masashi.honma@gmail.com>,
        linux-wireless@vger.kernel.org, Cedric.Izoard@ceva-dsp.com
Date: Wed, 11 Jan 2017 12:01:59 +0100
In-Reply-To: <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com> (sfid-20170111_113614_374251_1EB7EC8D)
References: <b72bc51c-1873-6178-9990-7d9e99ee4b88@gmail.com>
         <1484121737.23671.0.camel@sipsolutions.net>
         <aa60ffb2-b756-b807-4976-20f2eca6665d@gmail.com>
         <1484125220.23671.1.camel@sipsolutions.net>
         <12d8a797-6c51-4a79-2820-1f9e2e72b2f5@gmail.com>
         <1484128809.23671.11.camel@sipsolutions.net>
         <670a7439-50b9-4f07-1d7d-cb915547562e@gmail.com>
         (sfid-20170111_113614_374251_1EB7EC8D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2017-01-11 at 19:36 +0900, Masashi Honma wrote:
> On 2017年01月11日 19:00, Johannes Berg wrote:
> > Nevertheless, I don't have hardware to try to reproduce it, and I
> > can't
> > see any such issues (even with real forwarding, I even just wrote a
> > wpa_s test for that) in hwsim.
> > 
> > Even a photo of the crash on the VT would help. Or maybe you can
> > set up
> > netconsole on the wired interface?
> 
> Thanks but SSH console via wired interface and laptop display does
> not show any log...

Sure, ssh won't - I was thinking of netconsole:
https://www.kernel.org/doc/Documentation/networking/netconsole.txt

johannes
