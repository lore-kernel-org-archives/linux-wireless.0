Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:45134 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756027Ab0JLBvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 21:51:49 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0962978306
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 10:51:47 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: Antenna diversity in ath5k.
Date: Tue, 12 Oct 2010 10:51:55 +0900
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4CAF60F0.4030506@candelatech.com>
In-Reply-To: <4CAF60F0.4030506@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201010121051.55691.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat October 9 2010 03:20:32 Ben Greear wrote:
>  this, I wanted to see if anyone else was
> actively pursuing it.

someone pointed you to my patches. i have been using them since month locally 
and i think the are fine as a general API, but there has been some reluctance 
to get them merged. i still don't really get why. i will fix the one remaining 
issue i know of (don't allow antenna setting when if up) rebase them and 
bother luis again, soon... :) if you have any feedback or ideas for 
improvement, please let me know.

bruno
