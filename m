Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.236]:31796 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754656AbXK1TuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 14:50:19 -0500
Received: by nz-out-0506.google.com with SMTP id s18so1197417nze
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2007 11:50:19 -0800 (PST)
Message-ID: <f6ca9fed0711281150v5daf8836yad3a40f343473ac8@mail.gmail.com> (sfid-20071128_195024_127735_6EF58E2D)
Date: Wed, 28 Nov 2007 20:50:09 +0100
From: dragoran <drago01@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: mac80211 / iwl3945 + dynamic wep (again)
Cc: "Jouni Malinen" <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Dan Williams" <dcbw@redhat.com>,
	ipw3945-devel <ipw3945-devel@lists.sourceforge.net>,
	"Zhu Yi" <yi.zhu@intel.com>
In-Reply-To: <1196279236.6058.165.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <47494851.4070504@gmail.com>
	 <1195987773.4149.214.camel@johannes.berg> <474955E1.30603@gmail.com>
	 <f6ca9fed0711260650j749de7a3x3edc084ae820d2eb@mail.gmail.com>
	 <20071127033408.GB5698@jm.kir.nu> <474D75D9.7070908@gmail.com>
	 <1196268612.6058.157.camel@johannes.berg>
	 <f6ca9fed0711281145y26fa2dc1w5d57e9dc0e45c16b@mail.gmail.com>
	 <1196279236.6058.165.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 28, 2007 8:47 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>
>
> > > Just grap iw (from git.sipsolutions.net) and create a new monitor
> > > interface: ./iw dev wmaster0 interface add moni0 type monitor
> > > and then run tcpdump/wireshark on that.
> >
> > iw does not build here :
> > cc -I/lib/modules/`uname -r`/build//include -Wall
> > -I/lib/modules/`uname -r`/build/include -g   -c -o iw.o iw.c
> > iw.c:11:31: error: netlink/genl/genl.h: No such file or directory
> > iw.c:12:33: error: netlink/genl/family.h: No such file or directory
> > iw.c:13:33: error: netlink/genl/ctrl.h: No such file or directory
>
> Yeah, you need libnl-pre8.

ok will rebuild libnl and do the tests on friday.
