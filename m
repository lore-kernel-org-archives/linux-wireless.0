Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40650 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbcEaKfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 06:35:32 -0400
Message-ID: <1464690929.3076.25.camel@sipsolutions.net> (sfid-20160531_123536_960977_5BF5ACB8)
Subject: Re: [PATCH] iw: support setting frame subtype and reason code when
 deleting station
From: Johannes Berg <johannes@sipsolutions.net>
To: =?UTF-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 31 May 2016 12:35:29 +0200
In-Reply-To: <CACna6rwWBxCBSmJ1yhb8-Ai-74XtiYh9VCQFGDS2En4n67kmwQ@mail.gmail.com> (sfid-20160531_120349_582115_395912FD)
References: <1462376337-26902-1-git-send-email-zajec5@gmail.com>
	 <1464687856.3076.3.camel@sipsolutions.net>
	 <CACna6rwWBxCBSmJ1yhb8-Ai-74XtiYh9VCQFGDS2En4n67kmwQ@mail.gmail.com>
	 (sfid-20160531_120349_582115_395912FD)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-05-31 at 12:03 +0200, Rafał Miłecki wrote:
> On 31 May 2016 at 11:44, Johannes Berg <johannes@sipsolutions.net>
> wrote:
> > 
> > Applied.
> > 
> > On Wed, 2016-05-04 at 17:38 +0200, Rafał Miłecki wrote:
> > > 
> > > Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
> > Oddly enough, patchwork corrupted *this*, but not the From: line
> > ...
> This patch was sent before patchwork update, I guess crazy things
> could happen with old version and update could make things even more
> weird.
> 
> Hopefully all further patches will be OK :)
> 

Yeah, indeed, I realized that when I reviewed your other patch (the
channels one) which is perfectly correct in both places.

johannes
