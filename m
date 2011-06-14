Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail81.extendcp.co.uk ([79.170.40.81]:39141 "EHLO
	mail81.extendcp.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab1FNTMy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jun 2011 15:12:54 -0400
Date: Tue, 14 Jun 2011 19:47:47 +0100
From: Tony Houghton <h@realh.co.uk>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Mohammed Shafi <shafi.wireless@gmail.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@venema.h4ckr.net,
	linux-wireless <linux-wireless@vger.kernel.org>,
	camilo@mesias.co.uk, Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: Re: APSM, AR9285 and bus hangs
Message-ID: <20110614194747.23c3e01a@toddler> (sfid-20110614_211256_922657_DD76B6C3)
In-Reply-To: <BANLkTine2HDAwUnd5jJ=mwL25bJo-7zJSg@mail.gmail.com>
References: <BANLkTikFvkUj=JFrCsffz6Z78KdAEw-t0A@mail.gmail.com>
	<20110613132009.GA7133@redhat.com>
	<BANLkTi=eKBcV5OjP0qqLe6n9GsiwhYLejg@mail.gmail.com>
	<20110614100918.GA4450@redhat.com>
	<BANLkTimZFU_g5Ee4Ajh9MyFmWCvtj-Firw@mail.gmail.com>
	<BANLkTine2HDAwUnd5jJ=mwL25bJo-7zJSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 14 Jun 2011 19:47:35 +0800
Adrian Chadd <adrian@freebsd.org> wrote:

> I don't have any new thoughts, no. I think it's more likely something
> to do with how the bus is being setup, how APSM is being used, how
> power saving in general is handled, quirks of that chipset (all the
> laptops with problems have been a specific AMD chipset, right?)

No, mine's Intel Atom/NVidia ION LE. According to lspci it has an NVidia
MCP79 running the PCI Express etc.
