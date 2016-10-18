Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57785 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751476AbcJRT4a (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 18 Oct 2016 15:56:30 -0400
Message-ID: <1476820587.6425.52.camel@sipsolutions.net> (sfid-20161018_215633_516282_DA5593CC)
Subject: Re: Intel 7260 not working on 4.4.24 / armv7
From: Johannes Berg <johannes@sipsolutions.net>
To: Oliver Zemann <oliver.zemann@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Tue, 18 Oct 2016 21:56:27 +0200
In-Reply-To: <1dce4f5d-b905-9f26-17f3-d8b1ae0d1b13@gmail.com> (sfid-20161018_214426_857029_72ADE60C)
References: <b61ccf3c-1861-c8f8-ff7d-91c2b6ff4df5@gmail.com>
         <41e828b1-c340-d6c6-61f4-051c845820c8@gmail.com>
         <caecaf52-7237-2a86-e5cd-3c9666962391@dd-wrt.com>
         <80788796-5768-1650-dcef-59ccfbe7be6f@gmail.com>
         <fa098763-cdf6-03f8-6d75-0fa9dfb270e4@gmail.com>
         <1476817578.6425.40.camel@sipsolutions.net>
         <1dce4f5d-b905-9f26-17f3-d8b1ae0d1b13@gmail.com>
         (sfid-20161018_214426_857029_72ADE60C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-10-18 at 21:44 +0200, Oliver Zemann wrote:
> Is there some way to disable the bluetooth functionality?
> 

Not that I know of. It's kinda pointless though since you then wouldn't
have any functionality anyway?

I don't have the board you mentioned to Emmanuel, but I can try the
7260 on the Hummingboard.

I do know that, for example, on my old G5 powermac the newer Intel NICs
cause the system to be unable boot, so there sometimes are PCIe bus
incompatibilities.

johannes

(please quote properly)
