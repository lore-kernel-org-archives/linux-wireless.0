Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f202.google.com ([209.85.211.202]:37429 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755348AbZKIPzX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Nov 2009 10:55:23 -0500
Received: by ywh40 with SMTP id 40so2652818ywh.33
        for <linux-wireless@vger.kernel.org>; Mon, 09 Nov 2009 07:55:29 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <loom.20091108T191008-495@post.gmane.org>
References: <87f9e23c0910261352x60e17ef8ud859f91f36c43898@mail.gmail.com>
	 <200910262230.57957.mb@bu3sch.de>
	 <20091027100926.GA13391@hash.localnet>
	 <200910271129.10535.mb@bu3sch.de>
	 <loom.20091108T191008-495@post.gmane.org>
Date: Mon, 9 Nov 2009 10:55:28 -0500
Message-ID: <b6c5339f0911090755h133d849ld5387467c7fad3c3@mail.gmail.com>
Subject: Re: ath5k phy0: no further txbuf available, dropping packet
From: Bob Copeland <me@bobcopeland.com>
To: David Srbecky <dsrbecky@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 8, 2009 at 1:12 PM, David Srbecky <dsrbecky@gmail.com> wrote:
> Hi,
>
> Is there any progress with trying to solve this problem?

Yes, I believe the changes to the cab queue timing will fix it, but
I still need to do some testing on various queue settings before I
can send a patch.  In the meantime, we discussed the possibility of
simply continuing in the tx processing loop instead of bailing out for
incomplete descriptors; I don't forsee any problem with that approach.

-- 
Bob Copeland %% www.bobcopeland.com
