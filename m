Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f48.google.com ([74.125.83.48]:65002 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3AQXwN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jan 2013 18:52:13 -0500
Received: by mail-ee0-f48.google.com with SMTP id t10so1524105eei.35
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jan 2013 15:52:11 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] linux-firmware: add carl9170 firmware
Date: Fri, 18 Jan 2013 00:52:06 +0100
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Dan =?iso-8859-15?q?Hor=E1k?= <dan@danny.cz>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	"Stefan Lippers-Hollmann" <s.L-H@gmx.de>
References: <1342353398-3147-1-git-send-email-xose.vazquez@gmail.com> <50F5DD2F.2000907@gmail.com> <1358458004.15692.147.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1358458004.15692.147.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201301180052.07145.chunkeey@googlemail.com> (sfid-20130118_005217_868996_92D9649D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday, January 17, 2013 10:26:44 PM Ben Hutchings wrote:
> On Tue, 2013-01-15 at 23:50 +0100, Xose Vazquez Perez wrote:
> > On 01/14/2013 12:27 PM, Ben Hutchings wrote:
> > 
> > > OK, I've worked this out now: there are two post-processing steps
> > > required, one of which is done by './autogen.sh install', and one of
> > > which (add a checksum) is not done at all.  I've added that step to it
> > > and can now rebuild a bit-identical image.
> > > 
> > > So I've applied this, made a few fixes, and pushed.
> > 
> > Sorry, I took half sabbatical. Now cleaning inbox.
> > 
> > I believe Christian releases a new version(1.9.7) recently,
> > and I did send 1.9.6 months ago. It should be updated.

Depends. [This would be another question... what qualifies for
a new push to linux-firmware? Should there be one for every 
series-of-related-patches? release e.g.: 1.9.7, 1.9.8? Or after
the firmware passed the test of time?]

Anyway, the biggest 'new thing' in 1.9.7 was getting "Link Time 
Optimization" ready [1].
 
> I'm happy to take either a single patch for the new release or
> one patch for each commit in your repository, whichever you prefer.
Would it be possible to attach a carl9170fw-x.y.z-source.tar.xz/bz2/gz/zip
along the carl9170-1.fw binary instead of the source dump in carl9170fw/?
I've picked up all of Ben's carl9170fw patches and added them into 
carl9170fw-master. So in theory we are good to go.

Regards

Christian

[1] <https://github.com/chunkeey/carl9170fw/commit/1a2fbaf4f621cbb37f36637b1d4101f453474f7a>
