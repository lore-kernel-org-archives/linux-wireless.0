Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36911 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3FXSAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 14:00:11 -0400
Date: Mon, 24 Jun 2013 13:58:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2013-06-23
Message-ID: <20130624175826.GC1997@tuxdriver.com> (sfid-20130624_200034_764593_5E614076)
References: <20130623021351.GA2327@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130623021351.GA2327@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 23, 2013 at 03:13:51AM +0100, Gustavo Padovan wrote:
> Hi John,
> 
> A important fix to 3.10, this patch fixes an issues that was preventing the 
> l2cap info response command to be handled properly. Please pull. Thanks!
> 
>         Gustavo
>         
> ---
> The following changes since commit fcb3701849957917a234a61b58ad70ed35c83eda:
> 
>   brcmfmac: free primary net_device when brcmf_bus_start() fails (2013-06-13 13:24:12 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
> 
> for you to fetch changes up to 3f6fa3d489e127ca5a5b298eabac3ff5dbe0e112:
> 
>   Bluetooth: Fix invalid length check in l2cap_information_rsp() (2013-06-23 00:24:58 +0100)
> 
> ----------------------------------------------------------------
> Jaganath Kanakkassery (1):
>       Bluetooth: Fix invalid length check in l2cap_information_rsp()
> 
>  net/bluetooth/l2cap_core.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
