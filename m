Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f186.google.com ([209.85.222.186]:36384 "EHLO
	mail-pz0-f186.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760129Ab0EDSLh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 14:11:37 -0400
Received: by pzk16 with SMTP id 16so2043046pzk.22
        for <linux-wireless@vger.kernel.org>; Tue, 04 May 2010 11:11:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4BE05F6B.3060705@lwfinger.net>
References: <4BE05F6B.3060705@lwfinger.net>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 4 May 2010 11:11:16 -0700
Message-ID: <s2g43e72e891005041111tf4e5772dm1ce840e7d7374a85@mail.gmail.com>
Subject: Re: Philosophical question about channel selection
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 4, 2010 at 10:54 AM, Larry Finger <Larry.Finger@lwfinger.net> wrote:
> A question has been posed on the openSUSE wireless forum that I do not
> know how to answer.
>
> In a given neighborhood, there are 802.11g APs at roughly the same
> strength on channels 1 and 10 (yes - 10). As this configuration ensures
> that there are no clear channels, what would be the best choice? As I
> see it, the options are ch 1 with interference across the full channel
> width, ch 6 with interference only at the upper end, or ch 11. Which
> would get the best throughput?

Depends on how busy those APs are :) I'd use a minstrel type algorithm
to test :P

  Luis
