Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:56359 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122AbXJ0QA0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Oct 2007 12:00:26 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1011483nfb
        for <linux-wireless@vger.kernel.org>; Sat, 27 Oct 2007 09:00:24 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [Rt2400-devel] Please pull 'upstream' branch of rt2x00
Date: Sat, 27 Oct 2007 18:19:52 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200710271334.34192.IvDoorn@gmail.com> <20071027124735.GA16222@tuxdriver.com> <200710271645.37715.IvDoorn@gmail.com>
In-Reply-To: <200710271645.37715.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200710271819.52347.IvDoorn@gmail.com> (sfid-20071027_170037_267572_04574C4F)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 27 October 2007, Ivo van Doorn wrote:
> On Saturday 27 October 2007, John W. Linville wrote:
> > On Sat, Oct 27, 2007 at 01:34:34PM +0200, Ivo van Doorn wrote:
> > 
> > > Here is the 2.0.12 release of rt2x00.
> > > I noticed you only pulled 2 patches from the 2.0.11 release,
> > > and I don't know why you dropped the remaining patches.
> > > This means that this pull requests also contains the remaining
> > > 2.0.11 patches...
> > 
> > I haven't dropped them.  I'll be merging them for 2.6.25.  The patches
> > that got merged were sent as fixes for 2.6.24.
> 
> Ah ok. Thanks.

Btw, is there any branch in wireless-2.6 which in this case contains all
pending patches? (So those that also includes the patches which will
be merged for the next kernel).
I could use that branch to update rt2x00.git from.

Ivo
