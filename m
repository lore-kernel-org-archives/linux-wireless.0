Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57088 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751464AbdI1Pgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Sep 2017 11:36:54 -0400
Message-ID: <1506613011.8795.0.camel@sipsolutions.net> (sfid-20170928_173657_512005_60B09846)
Subject: Re: Query on iw command to set txq params
From: Johannes Berg <johannes@sipsolutions.net>
To: Phani Siriki <yvsg.phanis@gmail.com>,
        linux-wireless@vger.kernel.org
Date: Thu, 28 Sep 2017 17:36:51 +0200
In-Reply-To: <CADsGw2Zax=r7QBGYPO+bs0BTmb+JUVZ-Y-X+_gfRrKj8tQy27Q@mail.gmail.com> (sfid-20170921_200207_935243_80982052)
References: <CADsGw2Zax=r7QBGYPO+bs0BTmb+JUVZ-Y-X+_gfRrKj8tQy27Q@mail.gmail.com>
         (sfid-20170921_200207_935243_80982052)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2017-09-21 at 13:01 -0500, Phani Siriki wrote:
> Hi All
> 
> I am trying to apply the path mentioned below to set txq params using
> iw command.
> 
> http://www.spinics.net/lists/linux-wireless/msg42585.html

The patch is wrong (now?), it needs to use the *netdev* not just the
wiphy.

johannes
