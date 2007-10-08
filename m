Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.227]:10092 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184AbXJHUsy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Oct 2007 16:48:54 -0400
Received: by wx-out-0506.google.com with SMTP id h31so1434599wxd
        for <linux-wireless@vger.kernel.org>; Mon, 08 Oct 2007 13:48:53 -0700 (PDT)
Date: Mon, 8 Oct 2007 16:48:58 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 6/6] ath5k: Do not let the driver through for not yet
	supported radios
Message-ID: <20071008204858.GC7633@pogo> (sfid-20071008_214859_723217_E3CA7812)
References: <20071006010449.GA25022@pogo> <20071006011657.GA24862@pogo> <20071006011837.GB25022@pogo> <20071006011923.GC25022@pogo> <20071006011949.GD25022@pogo> <20071006012017.GE25022@pogo> <20071006012057.GF25022@pogo> <40f31dec0710070313k6514882bkf5676d06ced25c53@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0710070313k6514882bkf5676d06ced25c53@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Oct 07, 2007 at 03:13:28AM -0700, Nick Kossifidis wrote:
> NACK i have a better fix wich uses chip srev, i had commited it on
> ath5k branch on madwifi svn...
> 
> what's going on ? noone read my chagnes n ath5k branch on madwifi svn
> ? i did this change some time ago (over a month) and it seems you
> didn't even saw it...
> 
> http://madwifi.org/changeset/2703
> http://madwifi.org/changeset/2704
> 
> what happened to my changes ? you told me you would commit them here...

I had said I would but Jiri sent some patches based on your work which
I thought included your latest changes. Instead of bitching about
things you should start sending patches, that would be more helpful.

Anyway I actually like that approach more, thanks. John -- I'll send in a new
patch series.

        Luis
