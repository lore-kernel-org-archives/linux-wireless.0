Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:63656 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbZH1QXv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 12:23:51 -0400
MIME-Version: 1.0
In-Reply-To: <200908280934.53681.hs4233@mail.mn-solutions.de>
References: <43e72e890908271943s6dca1257g1f1e56d0347cc21d@mail.gmail.com>
	<200908280934.53681.hs4233@mail.mn-solutions.de>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 28 Aug 2009 09:23:33 -0700
Message-ID: <43e72e890908280923v376b5eeaub542201217f02fba@mail.gmail.com>
Subject: Re: ar9271 mailing list and driver project page
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: devel@linuxdriverproject.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>,
	Christoph Hellwig <hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 28, 2009 at 12:34 AM, Holger
Schurig<hs4233@mail.mn-solutions.de> wrote:
>> ar9271 and ar9170 seem to share a few things, one of which is
>> firmware upload. ar9271's firmware upload routine was modified
>> to make it match ar9170's as much as possible to share it on
>> ath.ko
>
> Is it true that most devices which will use ath.ko won't ever use
> firmware uploading?

For now only usb devices require firmware loading, but so does ar6k,
however I am not sure how fw upload works there so I cannot be certain
the way to upload fw will be the same as with ar9170 and ar9271.

> It's only a few Ath-USB devices, so maybe
> you could do an ath_fw.ko for this.

True, or ath_usb, or something, only thing is it might be overkill to
just have 1 fw upload routine on a module for sharing.

> (Somebody who's always working with embedded devices and likes to
> keeps small :-)

Hey thanks :)

  Luis
