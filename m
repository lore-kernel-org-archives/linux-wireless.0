Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jabba.london.02.net ([82.132.130.169]:47831 "EHLO mail.o2.co.uk"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932141Ab1BYOl0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 09:41:26 -0500
Date: Fri, 25 Feb 2011 14:35:39 +0000
From: Tony Houghton <h@realh.co.uk>
To: sedat.dilek@gmail.com
Cc: sedat.dilek@googlemail.com, Jonathan Nieder <jrnieder@gmail.com>,
	ath9k-devel@lists.ath9k.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Vivek Natarajan <vnatarajan@atheros.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: Re: ath9k causes lockups since kernel 2.6.35
Message-ID: <20110225143539.6e9cb46c@realh.co.uk>
In-Reply-To: <AANLkTinv-iP2ugHy2n23jwi2uuyJCoSXtekTj9QYvbXJ@mail.gmail.com>
References: <20110224182022.57e32862@toddler>
	<20110224200203.GB17412@elie>
	<AANLkTinv-iP2ugHy2n23jwi2uuyJCoSXtekTj9QYvbXJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 25 Feb 2011 08:57:11 +0100
Sedat Dilek <sedat.dilek@googlemail.com> wrote:

> Debian/experimental provides now 2.6.38-rc6 kernel packages, might be
> worth a test?

I just tried that and at first it looked as if it might be working,
because it successfully disabled and reenabled wireless (via
network-manager). But when I tried suspend it crashed on resuming. IIRC
I also tried the newest tagged version from git and that was a fail too.

FWIW this last crash was on battery power, but most of the time I've
been plugged in to the mains. I saw some commit messages about
power-saving mode but it didn't occur to me that battery/mains might
make a difference and it looks like it doesn't.
