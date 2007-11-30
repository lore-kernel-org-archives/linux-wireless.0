Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:8773 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755414AbXK3Ia4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 03:30:56 -0500
Received: by nf-out-0910.google.com with SMTP id g13so2169655nfb
        for <linux-wireless@vger.kernel.org>; Fri, 30 Nov 2007 00:30:54 -0800 (PST)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Please pull 'upstream' branch of rt2x00
Date: Fri, 30 Nov 2007 10:51:02 +0100
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200711272146.53518.IvDoorn@gmail.com> <200711272154.29350.IvDoorn@gmail.com> <20071129222641.GE32730@tuxdriver.com>
In-Reply-To: <20071129222641.GE32730@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200711301051.02596.IvDoorn@gmail.com> (sfid-20071130_083103_045250_E4F8C47B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 November 2007, John W. Linville wrote:
> On Tue, Nov 27, 2007 at 09:54:29PM +0100, Ivo van Doorn wrote:
> 
> > > Please merge the patches for 2.6.24
> 
> > Sorry that should be:
> > 08 - Only update rssi average approximation on receiving beacon frames.
> > 09 - Remove redundant code in rfkill setup
> > 10 - Cleanup rfkill
> 
> Actually it looks to me like 9 and 10 apply to code that isn't in
> 2.6.24.  8 looks like it is close, but it doesn't quite apply either.
> I'll try to massage it in -- hopefully Jeff won't mind the extra
> trouble when rebasing...

9 and 10 should apply cleanly since the rfkill code hasn't changed for quite
some time now. In fact I believe it hasn't changed since the initial merge
to 2.6.24-rc.
Anyway, I'll try to create a patch for the upstream-jgarzik branch this weekend,
that would safe you and jeff some work. :)

Ivo
