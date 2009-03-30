Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f160.google.com ([209.85.217.160]:35135 "EHLO
	mail-gx0-f160.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754326AbZC3AbB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Mar 2009 20:31:01 -0400
Received: by gxk4 with SMTP id 4so3890636gxk.13
        for <linux-wireless@vger.kernel.org>; Sun, 29 Mar 2009 17:30:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1238369777.5165.32.camel@maxim-laptop>
References: <1238369777.5165.32.camel@maxim-laptop>
Date: Sun, 29 Mar 2009 20:30:59 -0400
Message-ID: <b6c5339f0903291730v9dc3d12wd66df72eb439db2f@mail.gmail.com> (sfid-20090330_023110_831609_C05D3CE1)
Subject: Re: AR2425 - test report
From: Bob Copeland <me@bobcopeland.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	ath5k-devel <ath5k-devel@lists.ath5k.org>,
	Nick Kossifidis <mick@madwifi-project.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 29, 2009 at 7:36 PM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Then I turned off WPA2, switched to open mode.
> Suddenly download speeds increased to 2.9/3.0 Mbytes/s, and uploads
> speed increased too, don't remember how much. I use hardware crypto, but
> does it support AES? (Maybe this is due to the fact that atom is slow?)

Some cards do support AES -- but none of them in ath5k right now.
All the code is there but I tried it once, it didn't work immediately
so I gave up, heh.  Right now it does WEP and TKIP in hw, the rest in
software.

-- 
Bob Copeland %% www.bobcopeland.com
