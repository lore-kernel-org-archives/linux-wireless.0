Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58193 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LIUbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Dec 2011 15:31:35 -0500
Subject: Re: ath9k: reports wrong GI/bandwidth (bug)
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <CAJ-VmomHfArfn6sQhPb=k8cP_MJ-MX5rk1c1g8JgFp=1ce9adQ@mail.gmail.com> (sfid-20111209_204321_501825_0FF7DC8B)
References: <1323427001.3622.14.camel@jlt3.sipsolutions.net>
	 <CAJ-VmomHfArfn6sQhPb=k8cP_MJ-MX5rk1c1g8JgFp=1ce9adQ@mail.gmail.com>
	 (sfid-20111209_204321_501825_0FF7DC8B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Dec 2011 21:31:31 +0100
Message-ID: <1323462691.3615.0.camel@jlt3.sipsolutions.net> (sfid-20111209_213138_036704_20D347FB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-12-10 at 06:42 +1100, Adrian Chadd wrote:
> Can you see whether the -final- frame in an A-MPDU has the correct GI bit set?

In a dozen or so cases in the original capture file, it does seem to be
correct in those cases. Not that it helps much, we could've missed the
last one :-)

johannes

