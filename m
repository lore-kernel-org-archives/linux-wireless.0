Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34577 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113Ab0JDP7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Oct 2010 11:59:44 -0400
Received: by iwn5 with SMTP id 5so7074125iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 04 Oct 2010 08:59:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <9D3ED2EB2589B641B6CCA9F529CAA6A201018E47@exbe12.nasstar-t1.net>
References: <9D3ED2EB2589B641B6CCA9F529CAA6A2F258CB@exbe12.nasstar-t1.net>
 <AANLkTi=aBPTYZB62Jup4=10_D2wxEgVaBormJcZb6qyT@mail.gmail.com>
 <9D3ED2EB2589B641B6CCA9F529CAA6A2FC5433@exbe12.nasstar-t1.net>
 <AANLkTinAnawV3JThYNdovcBY4HaUOH-Sydwi1JKKoz+W@mail.gmail.com>
 <1285868215.5137.6.camel@jlt3.sipsolutions.net> <9D3ED2EB2589B641B6CCA9F529CAA6A201018E47@exbe12.nasstar-t1.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 4 Oct 2010 08:59:23 -0700
Message-ID: <AANLkTik7qF8=L-64hmT63KKNGCT-SvX=FObxbbkzSp2A@mail.gmail.com>
Subject: Re: [ath9k-devel] Modulation schemes on ath9k
To: Mike Pithouse <mike.pithouse@vegastream.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 4, 2010 at 8:41 AM, Mike Pithouse
<mike.pithouse@vegastream.com> wrote:
> Hi,
>
> Is anyone able to confirm whether or not it's possible (by any means) to set the MCS Index for an ath9k Access Point?

Please learn to bottom post:

http://en.wikipedia.org/wiki/Posting_style#Bottom-posting

Then you already had an answer to your question but you keep on
asking. The answer was we need API for this which is not present yet.
If you want to hack something around you can go ahead and try using
debugfs on ath9k.

  Luis
