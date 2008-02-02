Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.182]:51549 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764345AbYBBXiw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 18:38:52 -0500
Received: by py-out-1112.google.com with SMTP id u52so2420663pyb.10
        for <linux-wireless@vger.kernel.org>; Sat, 02 Feb 2008 15:38:51 -0800 (PST)
Message-ID: <43e72e890802021538s72158e2ete8b20fb5304a2ce1@mail.gmail.com> (sfid-20080202_233908_391868_E3C6C57E)
Date: Sat, 2 Feb 2008 18:38:48 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "bruno randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/3] ath5k: Add build option to enable hardware encryption
Cc: linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, jirislaby@gmail.com,
	mickflemm@gmail.com
In-Reply-To: <43e72e890802021041x63e41a0ei80d7ffbfade0b820@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080201133731.GH28995@ruslug.rutgers.edu>
	 <200802021134.41989.bruno@thinktube.com>
	 <43e72e890802021041x63e41a0ei80d7ffbfade0b820@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 2, 2008 1:41 PM, Luis R. Rodriguez <mcgrof@winlab.rutgers.edu> wrote:
> On Feb 1, 2008 9:34 PM, bruno randolf <bruno@thinktube.com> wrote:
>
> > hi luis!
> >
> > i think this is pretty much overkill. why would anyone say Y to that?
> > wouldn't it suffice to add that comment to the code and not bother the users?
> > developers would work on the code anyways.
>
> I am not sure if encryption is going to work similar in later
> chipsets, this would allow an easy way for developers/distributions
> tell users to say yes there for chipsets we know it works for, for
> other chipsets people can say no. If we're sure its the same across
> chipsets then lets not apply it but I am not sure of that. Anyone?

On second thought this hasn't happened yet so we can do so if it does later.

  Luis
