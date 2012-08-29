Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jubileegroup.co.uk ([217.147.177.250]:40136 "EHLO
	mail.jubileegroup.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2H2Hns (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Aug 2012 03:43:48 -0400
Date: Wed, 29 Aug 2012 08:43:41 +0100 (BST)
From: "G.W. Haywood" <ged@jubileegroup.co.uk>
To: Patrick Connolly <patrickc@alumni.ucsd.edu>
cc: linux-wireless@vger.kernel.org
Subject: Re: Question about ath9k/mac80211 Driver
In-Reply-To: <CAE3CJbmJ8JZzBKKJwYAL_6K_ossMK0HDCEkNLNfG-A4HzZSfzg@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1208290829230.3200@mail5.jubileegroup.co.uk> (sfid-20120829_094356_135335_FC4ED851)
References: <CAE3CJbkhmZ75gBjEToshQ2M9Xu7ciVrDtv8n2DVZepnhBoNt-Q@mail.gmail.com>
 <50365AC8.7030503@lwfinger.net> <CAE3CJbm5a0hZ8uWT8yU5Z8vbKX2HNwZ2uPUFULGA-3no1XFc_Q@mail.gmail.com>
 <5036660B.9020208@lwfinger.net> <CAE3CJbkodiw7kZ9F1PQrzZA2hSCF2PAwPAw-UHMwKhC2-6Ky2g@mail.gmail.com>
 <50381437.7040903@lwfinger.net> <CAE3CJb=Zi12MVpBNGE3kOu00x3b1sZ7S67TCyBty3GkPbtoJXA@mail.gmail.com>
 <CAE3CJbmK4nF2gR56Rkrrd8qWoCuLot=XD-a9koWxCzcDeOrg8A@mail.gmail.com>
 <CAE3CJbmJ8JZzBKKJwYAL_6K_ossMK0HDCEkNLNfG-A4HzZSfzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi there,

On Tue, 28 Aug 2012, Patrick Connolly wrote:

> ... Rates are the same as they were before the "iw   set bitrates"
> command.  ...  Can anyone comment on what is wrong?

I'm not using the same set of software that you're using, but I'm
interested in this because of a quite different problem that I'm
working on as time permits.  There may be some overlap.

These threads partly describe what I'm looking at:

https://dev.openwrt.org/ticket/7552
http://www.mail-archive.com/openwrt-devel@lists.openwrt.org/msg14450.html

As you can see the workaround for my immediate problem is alleged to
be setting the bitrates using iw, but I could not confirm that in tests.
In fact in later testing I came across problems apparently with iw itself:

root@Jubilee-wrt54gs-3:~# iw reg set GB
Segmentation fault

and I have now stopped using iw on these boxes because it crashes them
so often.

This is OpenWRT trunk on Linksys WRT54GSv1.1

Maybe just another data point.

--

73,
Ged.
