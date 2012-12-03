Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49465 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874Ab2LCSqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 13:46:42 -0500
Date: Mon, 3 Dec 2012 13:40:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@lists.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>,
	Waldemar Rymarkiewicz <waldemar.rymarkiewicz@tieto.com>
Subject: Re: [GIT] [NFC] 3.7 fix pull request
Message-ID: <20121203184056.GF26027@tuxdriver.com> (sfid-20121203_194646_431062_434CA4E0)
References: <20121129131452.GE12685@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20121129131452.GE12685@sortiz-mobl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I don't think this will make 3.7.  Any problem if I just pull it for 3.8?

John

On Thu, Nov 29, 2012 at 02:14:52PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> I'm hoping it's not too late for 3.7 fixes, so here is a last minute one:
> 
> This is an NFC LLCP fix for 3.7 and contains only one patch.
> 
> It fixes a potential crash when receiving an LLCP HDLC frame acking a frame
> that is not the last sent one. In that case we may dereference an already
> freed pointer.
> 
> 
> The following changes since commit 6bdd253f635f7b2ef027d116933a6c9ec148b87f:
> 
>   mac80211: fix remain-on-channel (non-)cancelling (2012-11-26 14:41:40 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-3.0.git tags/nfc-fixes-3.7-2
> 
> for you to fetch changes up to 289814918ce3af1296ac7d9b05508bde64e97348:
> 
>   NFC: Fix incorrect llcp pointer dereference (2012-11-28 18:42:04 +0100)
> 
> ----------------------------------------------------------------
> Waldemar Rymarkiewicz (1):
>       NFC: Fix incorrect llcp pointer dereference
> 
>  net/nfc/llcp/llcp.c |    5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> -- 
> Intel Open Source Technology Centre
> http://oss.intel.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
