Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.158]:19434 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757753AbYAaQls (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2008 11:41:48 -0500
Received: by fg-out-1718.google.com with SMTP id e21so659340fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2008 08:41:46 -0800 (PST)
Message-ID: <47A1FA47.2020801@gmail.com> (sfid-20080131_164153_003990_B79984BC)
Date: Thu, 31 Jan 2008 17:41:43 +0100
From: Jiri Slaby <jirislaby@gmail.com>
MIME-Version: 1.0
To: Nick Kossifidis <mickflemm@gmail.com>
CC: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com,
	johannes@sipsolutions.net
Subject: Re: [ath5k-devel] [PATCH] ath5k: Port to new bitrate/channel API
References: <20080130183824.GA7676@makis.domain.invalid>	 <43e72e890801310707u8e29468h3de981c0e3c72c52@mail.gmail.com>	 <40f31dec0801310732q3ac8fb84p875f31e16444c53e@mail.gmail.com>	 <43e72e890801310750o38faf05ckb9977e4e5d6341fa@mail.gmail.com> <40f31dec0801310816p3592bea0od2a19e0b15312e61@mail.gmail.com>
In-Reply-To: <40f31dec0801310816p3592bea0od2a19e0b15312e61@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/31/2008 05:16 PM, Nick Kossifidis wrote:
> Checkpatch shows up 40 points, most of them because it's over 80 lines
> and some of them because there are some missing spaces etc. I'm sure
> code is full of those so i believe we should better cleanup the whole
> code (also doing some sparse checking btw) once and for all (i told
> you in my previous mail that's what i want to do when i'm done with
> exams). It's really more easy for me to clean up the whole code after
> i'm done with exams than try to locate 40 places in this monster that
> might be fixed manually. I just need some time, i thought porting to
> the new API was urgent so i gave it full priority, cleanup can wait i
> guess (and we have to do it right and cautious).

It's fine to me.
