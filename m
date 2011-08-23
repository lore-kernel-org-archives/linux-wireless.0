Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41138 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab1HWSBu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Aug 2011 14:01:50 -0400
Received: by eyx24 with SMTP id 24so259927eyx.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Aug 2011 11:01:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E53E56A.1070801@broadcom.com>
References: <20110822112737.GA5936@stt008.linux.site>
	<4E525235.7060501@broadcom.com>
	<CAKprTDHO+Hh4g3WjGijDhPtzY5PiqR0GQ_zg8Uw46-qOVXpCRQ@mail.gmail.com>
	<4E525FC7.4070802@broadcom.com>
	<CAKprTDF0iFSAkYZiLQFLX+KumyLbzNUvHocKJyzK37Kv_79EFA@mail.gmail.com>
	<4E5367AA.8040406@broadcom.com>
	<CAKprTDFret5n-AH_B_Hu6E0+B4FEGJQ=jjYbGNy8ZD5R8ReFCg@mail.gmail.com>
	<4E53728B.3030803@broadcom.com>
	<20110823095348.GA5383@stt008.linux.site>
	<4E538309.1040203@broadcom.com>
	<20110823105341.GA5604@stt008.linux.site>
	<4E538DC3.7060906@broadcom.com>
	<CAKprTDHVcEgZvNE6Ububoaf1WH+LAcHD35YriNaj47JnsVL=Xg@mail.gmail.com>
	<4E53B6B0.8010605@broadcom.com>
	<CAKprTDGKfiGGZ7uEhT+U-DJ13+NexqPZKGQez7yShC40Heph_A@mail.gmail.com>
	<4E53E56A.1070801@broadcom.com>
Date: Tue, 23 Aug 2011 20:01:48 +0200
Message-ID: <CAKprTDFyDpqiiQ_8aRE+snxtHkufSrETrWBMtMc2DdVgKfdKAA@mail.gmail.com> (sfid-20110823_200153_732101_100C7F40)
Subject: Re: brcmsmac driver only works when sitting next to the AP
From: =?ISO-8859-1?Q?Camale=F3n?= <noelamac@gmail.com>
To: Roland Vossen <rvossen@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	"networkmanager-list@gnome.org" <networkmanager-list@gnome.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/8/23 Roland Vossen <rvossen@broadcom.com>:
> Hi,
>
> I can try to build the same source tree as you. If you got your source tree
> from Git, can you give me a SHA1 (git log) ? If you downloaded a package or
> tar ball, can you point to its location ?

I got the sources from here:

http://packages.debian.org/wheezy/linux-source-3.0.0

It's a deb package which contains "linux-source-3.0.0.tar.bz2".

> I assume that the version of your source tree matches your current kernel
> version ? (compare 'uname -r' to 'make kernelversion').

Yep, I think so:

root@stt300:/usr/src# uname -r
3.0.0-1-686-pae

root@stt300:/usr/src/linux-source-3.0.0# make kernelversion
3.0.0

Greetings,

-- 
Camaleón
