Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:63881 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758565AbZAWRvJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Jan 2009 12:51:09 -0500
Received: by ewy13 with SMTP id 13so3836849ewy.13
        for <linux-wireless@vger.kernel.org>; Fri, 23 Jan 2009 09:51:07 -0800 (PST)
Subject: Re: [BUG] latest wireless-testing (compat-wireless) doesn't work
 with iwl3945
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: "ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <1232672850.7913.6.camel@maxim-laptop>
References: <1232672850.7913.6.camel@maxim-laptop>
Content-Type: text/plain
Date: Fri, 23 Jan 2009 19:51:01 +0200
Message-Id: <1232733061.6513.2.camel@maxim-laptop> (sfid-20090123_185121_093641_6465F9E9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-01-23 at 03:07 +0200, Maxim Levitsky wrote:


I noticed another wierd bug, somehow iwl3945 manages now to break
suspend to disk (hands on suspend) but not suspend to ram.

Also, if I suspend via pm-hibernate on console, it works, but doesn't
work when I use ubuntu's menu.

System hangs on suspend to disk, I still can switch consoles, but can't
type anything there. will need to use ssh I guess.

Maxim Levitsky


