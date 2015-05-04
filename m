Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbEDPTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2015 11:19:47 -0400
Message-ID: <1430752777.17017.2.camel@redhat.com> (sfid-20150504_172013_675025_0B909716)
Subject: Re: b43 AP does not work
From: Dan Williams <dcbw@redhat.com>
To: Nerijus =?UTF-8?Q?Bali=C5=ABnas?= <nerijus@users.sourceforge.net>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 04 May 2015 10:19:37 -0500
In-Reply-To: <loom.20150502T191744-147@post.gmane.org>
References: <loom.20150502T183011-57@post.gmane.org>
	 <5544FFE5.5090706@lwfinger.net> <loom.20150502T190504-905@post.gmane.org>
	 <loom.20150502T191744-147@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2015-05-02 at 17:18 +0000, Nerijus Baliūnas wrote:
> Nerijus Baliūnas <nerijus@...> writes:
> 
> > IIRC I used "access point" mode of the NM applet and it worked, but now I
> > cannot find such option (at least in MATE). Is it somehow possible to still
> > use hostapd manually?
> 
> Just FYI - "access point" mode of the NM applet works (in Gnome). But it
> would still be nice to have hostapd working.NrybXǧv^)޺{.n+{*ޕ,{ayʇڙ,jfhzwj:+vwjmzZ+ݢj"!

If you want to use hostapd on the card and the system is running
NetworkManager, you can tell NM to ignore the device through the
"unmanaged-devices" option in NetworkManager.conf.  manpages have more
details.

Dan

