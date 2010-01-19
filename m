Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f190.google.com ([209.85.222.190]:61918 "EHLO
	mail-pz0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0ASWco convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jan 2010 17:32:44 -0500
Received: by pzk28 with SMTP id 28so330039pzk.4
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jan 2010 14:32:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100119215528.GB3078@tuxdriver.com>
References: <op.u6o9unx49lhzdc@linux-g0th.site> <20100119215528.GB3078@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 19 Jan 2010 14:32:24 -0800
Message-ID: <43e72e891001191432nc034e52hf58ba47ee0d6d819@mail.gmail.com>
Subject: Re: [PATCH 5/5 V2] b43: N-PHY: silence warnings, add missing call
To: "John W. Linville" <linville@tuxdriver.com>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"bcm43xx-dev@lists.berlios.de" <bcm43xx-dev@lists.berlios.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2010/1/19 John W. Linville <linville@tuxdriver.com>:
> On Mon, Jan 18, 2010 at 12:21:49AM +0100, Rafał Miłecki wrote:
>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>> New patch I didn't include earlier.
>
> Rafał,
>
> I just applied this 5-patch series and the preceding 7-patch series,
> and I had to fixup every single one manually due to the apparently
> busted mailer you are using.
>
>        User-Agent: Opera Mail/10.10 (Linux)
>
> The only reason I went to this trouble is because a) I want the
> N-phy stuff and b) you sent small, manageable patches.  But don't
> misunderstand -- I have no intention of continuing to fix these
> manually.
>
> Learn to use "git send-email" or find some other mailer to send
> your patches -- I recommend Mutt.  In any case, do not expect your
> patches to get merged unless in the future unless you can rectify
> this situation at your end.  I just don't have the bandwidth for
> dealing with crap like this.

In case this helps:

http://wireless.kernel.org/en/developers/Documentation/git-guide#Sending_patches

  Luis
