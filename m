Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:54961 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276AbXHSUhL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Aug 2007 16:37:11 -0400
Received: by ug-out-1314.google.com with SMTP id j3so452552ugf
        for <linux-wireless@vger.kernel.org>; Sun, 19 Aug 2007 13:37:09 -0700 (PDT)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH 12/30] rt2x00: Store firmware in memory
Date: Sun, 19 Aug 2007 22:44:17 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200708192018.30624.IvDoorn@gmail.com> <200708192025.39412.IvDoorn@gmail.com> <200708192054.29643.mb@bu3sch.de>
In-Reply-To: <200708192054.29643.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200708192244.17323.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 19 August 2007, Michael Buesch wrote:
> On Sunday 19 August 2007 20:25:39 Ivo van Doorn wrote:
> > +void rt2x00lib_free_firmware(struct rt2x00_dev *rt2x00dev)
> > +{
> > +	if (rt2x00dev->fw) {
> 
> No !=NULL check is needed.

I'll fix this.

Thanks :)

Ivo

> > +		release_firmware(rt2x00dev->fw);
> > +		rt2x00dev->fw = NULL;
> > +	}
> > +}
> 


