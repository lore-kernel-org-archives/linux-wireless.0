Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:30486 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbYKFSfI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2008 13:35:08 -0500
Received: by yw-out-2324.google.com with SMTP id 9so305428ywe.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Nov 2008 10:35:06 -0800 (PST)
Message-ID: <43e72e890811061035q48ea617ci42200bf539860a48@mail.gmail.com> (sfid-20081106_193517_741978_1F684DA7)
Date: Thu, 6 Nov 2008 10:35:06 -0800
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Keir <keirlawson@gmail.com>
Subject: Re: debugging 802.11s
Cc: linux-wireless@vger.kernel.org,
	"Javier Cardona" <javier@cozybit.com>,
	"Andrey Yurovsky" <andrey@cozybit.com>,
	YanBo <dreamfly281@gmail.com>
In-Reply-To: <e27b78a40811060534jf290197uc521a88ccd6fba2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <e27b78a40811060444y150553a9j81f5b14b84982754@mail.gmail.com>
	 <e27b78a40811060534jf290197uc521a88ccd6fba2b@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 6, 2008 at 5:34 AM, Keir <keirlawson@gmail.com> wrote:
> ---------- Forwarded message ----------
> From: Keir <keirlawson@gmail.com>
> Date: 2008/11/6
> Subject: debugging 802.11s
> To: devel@lists.open80211s.org
>
>
> Hello,
>
> I've been trying to set up an 802.11s network (between just two nodes
> initially), I have followed the howto at
> http://www.open80211s.org/trac/wiki/HOWTO-0.2.1

It would be good if someone *cough* could move this to the Linux
wireless wiki for iw when they get a chance:

http://wireless.kernel.org/en/users/Documentation/iw

> however when I run "iw
> dev mesh station dump" nothing is listed, I've set my machine's IPs to
> be 10.0.0.1 and 10.0.0.2 and they both have the same mesh id and on
> the default channel (ie I havent specified one).  I'm wondering how I
> would start finding out what the problem is? I'm using an ath5k card

I haven't tested this myself, sorry, but I've CC'd a few people who
might be able to help and have tested this on ath5k.

> with wireless-testing (quite a recent revsion, havent worked out how
> to get git to tell me which one exactly!)

git describe
git tag -l| grep master | tail -1

  Luis
