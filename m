Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:40642 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750973AbZKCSyH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Nov 2009 13:54:07 -0500
Received: by yxe17 with SMTP id 17so5684516yxe.33
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2009 10:54:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091103180055.GC4839@tuxdriver.com>
References: <200911021907.16271.csights@fastmail.fm>
	 <20091103180055.GC4839@tuxdriver.com>
Date: Tue, 3 Nov 2009 13:54:10 -0500
Message-ID: <b6c5339f0911031054g13443c17ma925014fb9b16ab8@mail.gmail.com>
Subject: Re: ath5k and ".local" dropout
From: Bob Copeland <me@bobcopeland.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: CSights <csights@fastmail.fm>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 3, 2009 at 1:00 PM, John W. Linville <linville@tuxdriver.com> wrote:
>
> The .local address relationship suggests multicast DNS, which suggests
> that ath5k might have a problem where it stops receiving multicast
> frames.  Does this "ring any bells" for anyone?

Yeah in fact I posted a patch to ath5k-devel but forgot to copy
linux-wireless. :)

We zero out the mcast filter for some reason, I'm not sure why.  Maybe missing
tildes in front of the zeroes or something.

-- 
Bob Copeland %% www.bobcopeland.com
