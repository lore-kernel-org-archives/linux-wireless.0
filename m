Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23645 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab3JLOZp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 10:25:45 -0400
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Sat, 12 Oct 2013 07:25:42 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Subject: Re: [PATCH 2/2] ath9k: add HT40 spectral scan capability
Message-ID: <20131012142542.GE29102@pogo> (sfid-20131012_162601_151369_A50397D1)
References: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
 <1381007769-11800-3-git-send-email-lorenzo.bianconi83@gmail.com>
 <20131010133118.GA32128@pandem0nium>
 <CAA2SeNJk2JxRfMzZd1VR=nA+e3gNoa+jdfcU8rZAUbsdGrHJ2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAA2SeNJk2JxRfMzZd1VR=nA+e3gNoa+jdfcU8rZAUbsdGrHJ2g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 11, 2013 at 01:33:49PM +0200, Lorenzo Bianconi wrote:
> Hi Simon,
> 
> > Hello Lorenzo,
> >
> > I've reviewed and tested your patch, this looks good! The old format still works, and
> > for a HT40+ channel I get your new format. Please find a few minor comments inline,
> > and feel free to add my Tested-by/Reviewed-by in the next round.
> >
> 
> Perfect, I will send a new patchset with changes you suggested me
> 
> > BTW, i failed to compile your UI[1]. I'm not familiar with QT, maybe you can add some
> > installation document (or Makefile or whatever)? :)
> 
> Sorry, I forgot to commit main.c :)
> You should install Qwt libraries (http://qwt.sourceforge.net/) since
> they are not compiled statically into the program and then run qmake
> and make. I tested UI with Qwt-6.1.0 and Qt-5.0.1
> Anyway, I will write a README

Please also extend the ath9k wiki with informatoin
referncing your project and feel free to also use the
wiki to even document your project as this is very ath9k
specific.

  Luis
