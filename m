Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:38048 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751024Ab0KQJ5B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Nov 2010 04:57:01 -0500
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0728067819
	for <linux-wireless@vger.kernel.org>; Wed, 17 Nov 2010 18:57:00 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: Re: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a DFS frequencies
Date: Wed, 17 Nov 2010 18:57:20 +0900
Cc: "ext Gabay, Benzy" <benzyg@ti.com>,
	"luciano.coelho@nokia.com" <luciano.coelho@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com> <676FD6AA0F002F49B89E70F0C5EFD22C136DEA03CC@dlee04.ent.ti.com> <1289982876.2522.157.camel@wimaxnb.nmp.nokia.com>
In-Reply-To: <1289982876.2522.157.camel@wimaxnb.nmp.nokia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201011171857.20200.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed November 17 2010 17:34:36 Juuso Oikarinen wrote:
> On Wed, 2010-11-17 at 02:25 -0600, ext Gabay, Benzy wrote:
> > Yet another question on this topic,
> > Ad-Hoc was designed originally for B mode only. Some companies extended
> > it to G also. Do we have MAC802.11 support for Ad-Hoc on 11a channels
> > these days?
> 
> Based on our testing, ad-hoc on 11a appears to work, tested between two
> linux-based devices.

Sure, we're using it all day & night... :)
In the few bands where it's permitted, of course.

bruno
