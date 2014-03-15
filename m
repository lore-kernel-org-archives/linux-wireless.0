Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:48803 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaCOPlZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Mar 2014 11:41:25 -0400
Message-ID: <1394898081.30941.5.camel@jlt4.sipsolutions.net> (sfid-20140315_164206_215043_133CB013)
Subject: Re: [mac80211_hwsim] BUG: unable to handle kernel paging request at
 ce1db404
From: Johannes Berg <johannes@sipsolutions.net>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Cc: Martin Pitt <martin.pitt@ubuntu.com>,
	Fengguang Wu <fengguang.wu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
Date: Sat, 15 Mar 2014 16:41:21 +0100
In-Reply-To: <CABPxzYJXQR=t6u33uFT5dU2y6sKK1QhCbBn+t4TmmNfVhNk5gw@mail.gmail.com> (sfid-20140315_163416_062883_7BDF2F58)
References: <20140305125703.GA7193@localhost>
	 <20140305132317.GB10880@localhost> <20140308121138.GA8359@localhost>
	 <20140312173446.GD2983@piware.de>
	 <CABPxzYLJA-gQjw2CwmL63dYEQ35h073k_vsp1uEM0B-sAmEwKQ@mail.gmail.com>
	 <1394896841.30941.4.camel@jlt4.sipsolutions.net>
	 <CABPxzYJXQR=t6u33uFT5dU2y6sKK1QhCbBn+t4TmmNfVhNk5gw@mail.gmail.com>
	 (sfid-20140315_163416_062883_7BDF2F58)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-03-15 at 21:03 +0530, Krishna Chaitanya wrote:

> > > what RC are u using? Default should be minstrel, i dont see
> > > a reason for rc alloc to fail (remote reason kmalloc failure),
> > > so did you disable RC completely? No prints either w.r.t RC either in
> > > dmesg?
> >
> > Pay attention to the .config.
> >
> Missed the attachment, thanks for pointing.
> As guessed the rate control is empty causing the registration fail.

It still shouldn't crash though. Looks like there's a fix in this
thread, can somebody verify & post it?

Thx,
johannes

