Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935750AbcJRTJ6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:09:58 -0400
Message-ID: <1476817796.6425.42.camel@sipsolutions.net> (sfid-20161018_211001_655861_9F438EC5)
Subject: Re: Intel 7260 not working on 4.4.24 / armv7
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Zemann <oliver.zemann@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Oct 2016 21:09:56 +0200
In-Reply-To: <1476817578.6425.40.camel@sipsolutions.net> (sfid-20161018_210624_954027_21817017)
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
         <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
         <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
         <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
         <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
         (sfid-20161018_182323_634850_59C65E60) <1476817578.6425.40.camel@sipsolutions.net>
         (sfid-20161018_210624_954027_21817017)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 21:06 +0200, Johannes Berg wrote:
> 
> The NICs *WiFi* function should be a PCIe device, but the USB
> connect/disconnect cycles suggest that there's something wrong with
> the
> electrical connection, which presumably causes the PCIe part of the
> device to never appear on the bus.
> 

Also, FWIW, I had our later NIC (8260) running on an ARMv7 (a
Hummingboard Pro i2ex or so), in both little (default) and big endian
modes. I haven't tried the 7260 but conceivably could.

johannes
