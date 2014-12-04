Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34094 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116AbaLDQaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 11:30:12 -0500
Date: Thu, 4 Dec 2014 11:28:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Linux NFC <linux-nfc@ml01.01.org>
Subject: Re: [GIT] [3.19] NFC update
Message-ID: <20141204162835.GA2842@tuxdriver.com> (sfid-20141204_173017_046758_C19303A5)
References: <20141202223749.GA31964@ribalta.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141202223749.GA31964@ribalta.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 02, 2014 at 11:37:49PM +0100, Samuel Ortiz wrote:
> Hi John,
> 
> This is the NFC pull request for 3.19.
> 
> With this one we get:
> 
> - NFC digital improvements for DEP support: Chaining, NACK and ATN
>   support added.
> 
> - NCI improvements: Support for p2p target, SE IO operand addition,
>   SE operands extensions to support proprietary implementations, and
>   a few fixes.
> 
> - NFC HCI improvements: OPEN_PIPE and NOTIFY_ALL_CLEARED support,
>   and SE IO operand addition.
> 
> - A bunch of minor improvements and fixes for STMicro st21nfcb and
>   st21nfca
> 
> Thanks in advance for pulling that one in.
> 
> 
> The following changes since commit 18ca43823f3ce111c6efb8cc90d9f35246527727:
> 
>   mwifiex: add Tx status support for ACTION frames (2014-11-25 14:09:57 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/sameo/nfc-next.git tags/nfc-next-3.19-1
> 
> for you to fetch changes up to e479ce479743984a5d4581749f9aaa9c3bfd65e4:
> 
>   NFC: NCI: Fix max length of General Bytes in ATR_RES (2014-12-02 22:59:28 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
