Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43432 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755424AbZAXUlp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 15:41:45 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sat, 24 Jan 2009 12:41:44 -0800
Date: Sat, 24 Jan 2009 12:41:07 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: "Diego E. 'Flameeyes' Petteno`" <flameeyes@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Tony Vroon <tony@linx.net>
Subject: Re: [ANN] crda v1.0.0
Message-ID: <20090124204107.GE22475@tesla> (sfid-20090124_214147_416978_D4965584)
References: <1232812557.19657.6.camel@localhost> <1232813139-21462-1-git-send-email-flameeyes@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1232813139-21462-1-git-send-email-flameeyes@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 24, 2009 at 08:05:38AM -0800, Diego E. 'Flameeyes' Petteno` wrote:
> Rather than parallel build there is a change in Makefile that breaks
> building with --as-needed, I've fixed it in the patch I'm sending.

Thanks, I'll apply as soon as I get the patch that applies and will release 1.0.1,
I'll also remove that pesky "v" too as requested.

  Luis
