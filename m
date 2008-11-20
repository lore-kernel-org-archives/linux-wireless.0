Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:49792 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbYKTTTV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2008 14:19:21 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Nov 2008 11:19:21 -0800
Date: Thu, 20 Nov 2008 11:19:19 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: tduckett <duck@tdux.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Error compiling.    Please help
Message-ID: <20081120191919.GB5899@tesla> (sfid-20081120_201924_552052_C986DBAB)
References: <002d01c94b03$c2544ee0$0200f00a@video1>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <002d01c94b03$c2544ee0$0200f00a@video1>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2008 at 03:33:02AM -0800, tduckett wrote:
> I never seem to be able to get things compiled  This is what I get when I
> run make.  What do I need to do to get this to work?

Seems compat-wireless-old needs some b44 2.6.23 backport love and no one
cares. Move to at least 2.6.27.

  Luis
