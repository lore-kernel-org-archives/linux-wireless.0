Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.189]:59515 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753465AbZAVJTq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 04:19:46 -0500
Received: by fk-out-0910.google.com with SMTP id f33so615579fkf.5
        for <linux-wireless@vger.kernel.org>; Thu, 22 Jan 2009 01:19:44 -0800 (PST)
To: Pavel Roskin <proski@gnu.org>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
	orinoco-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [Orinoco-devel] [PATCH] orinoco: trivial cleanup in alloc_orinocodev
References: <200901212155.32754.arvidjaar@mail.ru>
	<1232569292.10843.13.camel@dv>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 22 Jan 2009 11:19:41 +0200
In-Reply-To: <1232569292.10843.13.camel@dv> (Pavel Roskin's message of "Wed\, 21 Jan 2009 15\:21\:32 -0500")
Message-ID: <87iqo7lmtu.fsf@litku.valot.fi> (sfid-20090122_101953_089753_1F97EFA3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin <proski@gnu.org> writes:

> By the way, I made a patch that adds all C sources in
> drivers/net/wireless/orinoco and ran it through checkpatch.pl.

You can use checkpatch's --file argument directly, no need to create
patches manually :)

-- 
Kalle Valo
