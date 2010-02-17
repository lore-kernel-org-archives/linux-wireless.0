Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f197.google.com ([209.85.211.197]:54573 "EHLO
	mail-yw0-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756189Ab0BQU51 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Feb 2010 15:57:27 -0500
References: <1266356185-10324-1-git-send-email-mjg@redhat.com> <20100217052247.GD7160@core.coreip.homeip.net> <20100217180342.GA22522@srcf.ucam.org> <22ee4e771002171043u2aaf97vd73c1090c2fce901@mail.gmail.com> <20100217191708.GA15554@core.coreip.homeip.net> <22ee4e771002171142q1496842ap4079026a5c0be8c6@mail.gmail.com> <20100217195435.GA15742@core.coreip.homeip.net> <22ee4e771002171218t69cc4348ia0300a645ce9763d@mail.gmail.com>
Message-Id: <069C4DAE-598D-45F1-99B5-DA5BAF718179@gmail.com>
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
In-Reply-To: <22ee4e771002171218t69cc4348ia0300a645ce9763d@mail.gmail.com>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH 1/2] input: Add KEY_RFKILL
Date: Wed, 17 Feb 2010 12:52:06 -0800
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
	"marcel@holtmann.org" <marcel@holtmann.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 17, 2010, at 12:18 PM, Christian Lamparter <chunkeey@googlemail.com 
 > wrote:

> On Wed, Feb 17, 2010 at 8:54 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
>>
>> Is there anything currently in works that would make use of this  
>> button?
>> I do not want to allocate keycode "for the future" which may never  
>> come.
>> We did it with KEY_BATTERY but I do not think anyone actually uses  
>> it.
>
> Of course, there are lots of routers:
>
> Linksys: wrt160nl
> Netgear: wnr2000, wndr3700
> TP-Link: wr1043n, ... wr741nd
> TrendNET: TEW-632BRP
> Planex: MZK-W300NH,  MZK-W04NU
> ...
>
> And a few new client adapters, I know about:
> TP-Link: WN821 v2, WN721N, WN727N
> Netgear: WNDA3100 v2
> ...
>
> (Not to mention all the coming products).

Sorry, I was not clear enough. I meant something in works in Linux  
software stack, I was aware that certain router have these buttons  
already.

-- 
Dmitry

