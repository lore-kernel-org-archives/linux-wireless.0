Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:12324 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbXIFSCl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 14:02:41 -0400
Received: by ug-out-1314.google.com with SMTP id z38so199936ugc
        for <linux-wireless@vger.kernel.org>; Thu, 06 Sep 2007 11:02:40 -0700 (PDT)
To: Inaky Perez-Gonzalez <inaky@linux.intel.com>
Subject: Re: [PATCH V3] Add iwlwifi wireless drivers
Date: Thu, 6 Sep 2007 20:13:02 +0200
Cc: dragoran <drago01@gmail.com>, linux-wireless@vger.kernel.org,
	johannes@sipsolutions.net
References: <f6ca9fed0709041056rf44bb78ic7b5a516d6a3187a@mail.gmail.com> <200709061847.53659.IvDoorn@gmail.com> <200709061054.22492.inaky@linux.intel.com>
In-Reply-To: <200709061054.22492.inaky@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709062013.03203.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 06 September 2007, Inaky Perez-Gonzalez wrote:
> On Thursday 06 September 2007, Ivo van Doorn wrote:
> > >
> > > Can you add 'uwb' [for ultrawideband radios]? That way I could start to use it. A
> > > Doc file would help enourmously also :)
> > 
> > I'll create a doc file this weekend which will explain the sysfs files
> > and some instructions for drivers that want to implement it.
> 
> Thanks,
> 
> > I'm not familiar with ultrawideband radios, don't they fall under the same
> > catagory as wireless lan?
> 
> Nope, totally different beast; see linuxuwb.org. UWB is kind of like bluetooth 
> on esteroids, for PAN applications. Wireless USB (for eaxmple) uses a UWB radio.

Ah ok.
Well if there will be users, I'll create a patch to add the UWB to the list.
Patch will, just like the doc file, follow this weekend.

Ivo
