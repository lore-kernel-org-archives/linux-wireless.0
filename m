Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:45222 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab1KXJEH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Nov 2011 04:04:07 -0500
Message-ID: <4ECE0884.70005@neratec.com> (sfid-20111124_100413_482107_A66C6A80)
Date: Thu, 24 Nov 2011 10:04:04 +0100
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Adrian Chadd <adrian@freebsd.org>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net,
	shafi.wireless@gmail.com, nbd@openwrt.org
Subject: Re: [PATCH 0/2] ath9k: DFS radar detection
References: <1320770044-12271-1-git-send-email-zefir.kurtisi@neratec.com>	<20111115143755.GB2483@tuxdriver.com>	<CAB=NE6WLvLc2UpuQ2RYagN2OhwvEZZuYTUY+Ak+wFmBPH9EfUQ@mail.gmail.com>	<4ECD1B40.1050203@neratec.com> <CAJ-Vmon=VWhPQHJ9LJAy6YA9ER-rGRpWD8oKLf9Nd+DCirF0Eg@mail.gmail.com>
In-Reply-To: <CAJ-Vmon=VWhPQHJ9LJAy6YA9ER-rGRpWD8oKLf9Nd+DCirF0Eg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/24/2011 09:40 AM, Adrian Chadd wrote:
> On 24 November 2011 00:11, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>> Luis,
>>
>> any pending concerns or feedback before I start working on v2?
> 
> What's your ETA for getting the radar classification stuff done?
> 
> I'd like to evaluate the radar classification code and how it all ties
> together. :)
> 
> Thanks,
> 
> 
> adrian

Hi Adrian,

I'm stuck in my step-by-step approach, i.e. to get the pulse detection upstream first and then get back to the detection stuff. Just under-estimated how long it takes to get those few lines accepted...

Hopefully we'll have something to evaluate soon.



Zefir

