Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60538 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751300AbdEPURO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 May 2017 16:17:14 -0400
Message-ID: <1494965830.7785.0.camel@sipsolutions.net> (sfid-20170516_221717_443191_E7A71917)
Subject: Re: [PATCH] mac80211: Validate michael MIC before attempting packet
 decode.
From: Johannes Berg <johannes@sipsolutions.net>
To: mike@hellotwist.com
Cc: Jouni Malinen <j@w1.fi>, linux-wireless@vger.kernel.org
Date: Tue, 16 May 2017 22:17:10 +0200
In-Reply-To: <CAKXXJEwTWEeBP3gS6nnAxrhim1XbHGjiWZRmAGnDZdizD=1nzw@mail.gmail.com> (sfid-20170516_215707_335790_F75E7006)
References: <CAKXXJEzWfNrQxquCzA5dkD5=xCXWyeAC+_yBT35N1oDk-H_Buw@mail.gmail.com>
         <20170510122458.GA4796@w1.fi>
         <CAKXXJEymJXEp70bUMuNCxDAA1CLCOJN4DjnPBkf5oh6Nqn7JQA@mail.gmail.com>
         <1494579146.32348.3.camel@sipsolutions.net>
         <CAKXXJEwTWEeBP3gS6nnAxrhim1XbHGjiWZRmAGnDZdizD=1nzw@mail.gmail.com>
         (sfid-20170516_215707_335790_F75E7006)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2017-05-16 at 15:57 -0400, Michael Skeffington wrote:
> Johannes,
> 
> Thank you for that.  I need to make a quick hack to send an invalid
> MIC packet from another device to test the countermeasures.  Should I
> submit a new patch with this change when I've completed testing or
> are you already prepared to do so?

Please do, you're able to test it, and I'm not really all that familiar
with that particular driver either, even if I maintain mac80211 :)

johannes
