Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:34086 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab1HOLJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 07:09:27 -0400
Subject: Re: [iwl4965] Microcode SW error detected
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Bernhard Schmidt <bschmidt@freebsd.org>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110608134721.GA2283@redhat.com>
References: <1306151106.2066.60.camel@x61.thuisdomein>
	 <201106070832.49048.bschmidt@freebsd.org>
	 <20110607145435.GA5179@redhat.com>
	 <1307474580.2342.7.camel@x61.thuisdomein>
	 <20110608134721.GA2283@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Aug 2011 12:51:56 +0200
Message-ID: <1313405516.24749.17.camel@x61.thuisdomein> (sfid-20110815_130932_269945_EF859CA9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-06-08 at 15:47 +0200, Stanislaw Gruszka wrote:
> It could be possible fix. Why you can not simply patch and see if errors
> are still there? If after a week or so there will be no errors, we could
> consider bug fixed, otherwise well ... still will need looking around
> for fix.
> 
> I just posted patch that remove these "plcp health check" and related
> code on -next anyway, because I don't think this is something that we
> need.

0) This is just to note that I haven't yet tried to see if you're small
patch helps. I still hope to do that as I have not given up on this
issue. Feel free to prod me if I again disappear for too long and you
loose your patience.

1) By the way, I still see this error (every now and then) in my logs.
Most recently while running v3.0.1, so it appears not to be fixed by
recent updates for iwl4965 (if any).


Paul Bolle

