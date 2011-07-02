Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm17.bullet.mail.bf1.yahoo.com ([98.139.212.176]:29615 "HELO
	nm17.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754571Ab1GBMj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Jul 2011 08:39:57 -0400
Message-ID: <1309610075.77698.YahooMailClassic@web161606.mail.bf1.yahoo.com> (sfid-20110702_144000_661457_8D8E4FBB)
Date: Sat, 2 Jul 2011 05:34:35 -0700 (PDT)
From: Walter Goldens <goldenstranger@yahoo.com>
Subject: Re: [PATCH 3/6] zd1211rw: only update HW beacon if new beacon differs from currect
To: linux-wireless@vger.kernel.org,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Cc: Daniel Drake <dsd@gentoo.org>, Ulrich Kunitz <kune@deine-taler.de>
In-Reply-To: <20110620114238.964.59892.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



--- On Mon, 6/20/11, Jussi Kivilinna <jussi.kivilinna@mbnet.fi> wrote:

> This appears to make device work in AP-mode
> (dtim_period=1) somewhat more stable.
> 
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

Jussi,

I ran a hostapd AP with a zd1211b device, and while the stability is relatively OK, throughput appears to be below-par. The most I was able to get was about 3.5 megabits. Do you experience any throughput issues yourself and what is the average speed you see when you transfer files?

Walter
