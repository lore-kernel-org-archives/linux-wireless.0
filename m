Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:60678 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757820Ab3BKTBg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Feb 2013 14:01:36 -0500
Message-ID: <1360609295.2028.44.camel@joe-AO722> (sfid-20130211_200141_548348_1B4586C3)
Subject: Re: [PATCH 01/14] cw1200: v4: low-level hardware I/O functions
From: Joe Perches <joe@perches.com>
To: Solomon Peachy <pizza@shaftnet.org>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Feb 2013 11:01:35 -0800
In-Reply-To: <20130211185322.GB3123@shaftnet.org>
References: <1360355527-12159-1-git-send-email-pizza@shaftnet.org>
	 <1360355527-12159-2-git-send-email-pizza@shaftnet.org>
	 <1360372559.13487.14.camel@joe-AO722> <20130211185322.GB3123@shaftnet.org>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-11 at 13:53 -0500, Solomon Peachy wrote:
> On Fri, Feb 08, 2013 at 05:15:59PM -0800, Joe Perches wrote:
> > Could you please run your patches through
> > scripts/checkpatch.pl --strict
> 
> If you think it's bad now, you should have seen the state of the code 
> when I first "inherited" it.  :)

No doubt, but that wasn't my point.

> Question -- as a matter of policy, is the goal to have a completely 
> clean checkpatch run?  I get that there should be no ERRORs, but 
> WARNINGs/CHECKs are not considered fatal for a reason, right?

No.  It's just a guideline.  As far as I'm concerned,
ignore every checkpatch message you don't agree with.

Just be aware that there's a tool to help you get your
code looking more like what most others generally consider
"kernel style".

Though when you add "new" code, stuff like

	> +     u32 sdio_reg_addr_17bit ;

is untidy because of the space before the semicolon.


