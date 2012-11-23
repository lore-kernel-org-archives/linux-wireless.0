Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:51588 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788Ab2KWLSZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Nov 2012 06:18:25 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com
Subject: Re: [PATCH] mac80211: Fix macro definitions in Mesh
References: <1353635958-12298-1-git-send-email-yeohchunyeow@gmail.com>
	<CAG6hwVPxVsR2JCEiHSBCho1fwe4igd1q6o9BL_-ei=K8RHXa5g@mail.gmail.com>
Date: Fri, 23 Nov 2012 13:18:12 +0200
In-Reply-To: <CAG6hwVPxVsR2JCEiHSBCho1fwe4igd1q6o9BL_-ei=K8RHXa5g@mail.gmail.com>
	(Thomas Pedersen's message of "Thu, 22 Nov 2012 18:42:41 -0800")
Message-ID: <87ip8wwosr.fsf@purkki.adurom.net> (sfid-20121123_121829_658024_9CA813F3)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas Pedersen <thomas@cozybit.com> writes:

> On Thu, Nov 22, 2012 at 5:59 PM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>> Macro definitions should be static inlines.
>
> Then maybe this patch should do that as well? :)

Only one logical change per patch ;)

-- 
Kalle Valo
