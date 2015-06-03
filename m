Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:32852 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932487AbbFCTEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Jun 2015 15:04:12 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Willy Tarreau <w@1wt.eu>
Cc: Scott Branden <sbranden@broadcom.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Stable <stable@vger.kernel.org>, Andrew Kurn <kurn@sfu.ca>
Subject: Re: New USB ID 2001:3c25
References: <556E6000.90402@lwfinger.net>
	<6A6FBA3BBCB70741B2E7FD80BFDD32DB2B33CF50@SJEXCHMB10.corp.ad.broadcom.com>
	<20150603175412.GA7362@1wt.eu>
Date: Wed, 03 Jun 2015 21:01:09 +0200
In-Reply-To: <20150603175412.GA7362@1wt.eu> (Willy Tarreau's message of "Wed,
	3 Jun 2015 19:54:12 +0200")
Message-ID: <877frkfwga.fsf@nemi.mork.no> (sfid-20150603_210416_887703_4D4A2A86)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Willy Tarreau <w@1wt.eu> writes:
> On Wed, Jun 03, 2015 at 05:50:49PM +0000, Scott Branden wrote:
>> Hi Larry,
>> 
>> There is no problem applying this patch to the stable tree.
>> I didn't know it was my responsibility to inform the stable mailing list every time a patch is accepted
>> in the latest kernel that could be applied to the stable tree?
>
> Just adding a Cc: stable@... in the commit message is enough to get it
> automatically queued once applied. Please check SubmittingPatches and
> stable_kernel_rules.txt for more information.

It isn't absolutely clear to me that those rules applies to "wireless",
being a sub-subsystem of "net".  Quoting from stable_kernel_rules.txt :

"- If the patch covers files in net/ or drivers/net please follow netdev stable
   submission guidelines as described in
   Documentation/networking/netdev-FAQ.txt"

And the netdev-FAQ.txt goes into great detail describing the procedure,
which basically is "Give davem a hint that the patch should go to
stable".  (and I'd like to note that this works very well in practice).

But I have noticed that some stable patches seem to flow more directly
into stable from "wireless" than from the rest of "net". I just don't
think the current _written_ docs support that procedure.  Those docs
are possibly wrong?  You should probably know much better than me :)


Bjørn
