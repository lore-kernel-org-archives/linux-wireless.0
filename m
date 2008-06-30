Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:43425 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752522AbYF3UQW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 16:16:22 -0400
Received: by ug-out-1314.google.com with SMTP id h2so306961ugf.16
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jun 2008 13:16:22 -0700 (PDT)
Message-ID: <48693F0C.4060405@gmail.com> (sfid-20080630_221626_238779_0C090E97)
Date: Mon, 30 Jun 2008 21:16:12 +0100
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, proski@gnu.org,
	orinoco-devel@lists.sourceforge.net
Subject: Re: [RFC PATCH 00/19] orinoco: WPA for Agere based cards
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com> <20080630192820.GA878@tuxdriver.com>
In-Reply-To: <20080630192820.GA878@tuxdriver.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

John W. Linville wrote:
> On Sat, Jun 28, 2008 at 07:38:06PM +0100, kilroyd@googlemail.com wrote:
>> This patch series enables WPA on Agere based orinoco devices. An
>> earlier version has been available on the orinoco-devel list for a
>> while. I'm looking to get more feedback and testing of these patches,
>> so hopefully they can go into the kernel.
> 
> How "RFC" are these patches?  The release of 2.6.26 draws near.
> Should I merge these now so they will be in 2.6.27?

I'd be inclined to hold off merging for a bit.

Although rock solid for me, there has been very little feedback on these patches in orinoco-devel.

Patches 01 and 02 are trivial and should be OK to merge now if we want.

The main concern I have is that patch 09/19 may adversely affect spectrum_cs and the other symbol based cards. This could be avoided by invoking the symbol firmware download only from spectrum_cs, but I don't know if this is necessary.

I've been able to run/test all the other changes to my satisfaction on an Agere based card.


Dave.
