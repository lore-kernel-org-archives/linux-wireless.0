Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36663 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbaE3SAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 May 2014 14:00:12 -0400
Date: Fri, 30 May 2014 13:42:59 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux NFC <linux-nfc@ml01.01.org>,
	Linux Wireless <linux-wireless@vger.kernel.org>
Subject: Re: [GIT] [3.16] NFC update
Message-ID: <20140530174259.GF24054@tuxdriver.com> (sfid-20140530_200020_220186_87E7A0F6)
References: <20140529232016.GA19965@zurbaran>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140529232016.GA19965@zurbaran>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 30, 2014 at 01:20:16AM +0200, Samuel Ortiz wrote:
> Hi John,
> 
> Hopefully not too late for a last NFC pull request for 3.16.
> We have:
> 
> - Felica (Type3) tags support for trf7970a
> - Type 4b tags support for port100
> - st21nfca DTS typo fix
> - A few sparse warning fixes
> 
> Thanks in advance for pulling them in.
> 
> The following changes since commit ef1b075c15d55c71200c63450756a9bb51ce2a60:
> 
>   mwifiex: use 'const' qualifier for 2nd arg of mwifiex_tdls_add_ht_oper (2014-05-22 14:21:12 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git nfc-next-3.16-2
> 
> for you to fetch changes up to 6857bb96271cd40ffb38825d43897d716310e3db:
> 
>   NFC: trf7970a: Add support for Felica Type 3 tags (2014-05-26 01:28:28 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
