Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-g21.free.fr ([212.27.42.2]:3190 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751332AbbHFGaJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Aug 2015 02:30:09 -0400
From: Julien Cubizolles <j.cubizolles@free.fr>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: firmware in a bad state (module mwifiex)
References: <871tfzast5.fsf@free.fr>
	<0e2dc4e2bd9f4486979cedb4c47e60f2@SC-EXCH04.marvell.com>
	<87zj26z1pd.fsf_-_@free.fr>
	<d74ef56802d24c8e90e1b82eb5003172@SC-EXCH04.marvell.com>
	<87oaim85fq.fsf@free.fr>
	<e4dd6d588a114db8894e0abbeb34fbc7@SC-EXCH04.marvell.com>
Date: Thu, 06 Aug 2015 08:30:07 +0200
In-Reply-To: <e4dd6d588a114db8894e0abbeb34fbc7@SC-EXCH04.marvell.com>
	(Amitkumar Karwar's message of "Wed, 5 Aug 2015 09:54:01 +0000")
Message-ID: <87wpx9nd3k.fsf@free.fr> (sfid-20150806_083014_010153_0762F766)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Amitkumar Karwar <akarwar@marvell.com> writes:


> Thanks for reporting this. We will take a look at this right away.
> We don't have significant changes after 4.2.0-rc3. 

Well there were the two patches you pointed at that fixed a very serious
problem for me. Actually are these included in some branch of the main
kernel git tree ? I couldn't find the commit for
http://www.spinics.net/lists/netdev/msg334367.html at
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/ 

> You can try to find older working commit.

I'm afraid that will be difficult since this driver has been broken for
me since the 3.19 series.

Thanks again for your very precious help.

Regards,

Julien.
