Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42801 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaKGTFb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:05:31 -0500
Date: Fri, 7 Nov 2014 11:05:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 3/3] ath: ath9k: use debugfs_create_devm_seqfile() helper
 for seq_file entries
Message-ID: <20141107190530.GB4694@kroah.com> (sfid-20141107_200533_274184_52EC85B6)
References: <1414498752-9746-1-git-send-email-arend@broadcom.com>
 <1414498752-9746-4-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414498752-9746-4-git-send-email-arend@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 28, 2014 at 01:19:12PM +0100, Arend van Spriel wrote:
> Use the helper to get rid of the file operations per debugfs file. The
> struct ath9k_softc pointer is set as device driver data to be obtained
> in the seq_file read operation.
> 
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> Acked-by: John W. Linville <linville@tuxdriver.com>
> ---
>  drivers/net/wireless/ath/ath9k/ahb.c   |   1 +
>  drivers/net/wireless/ath/ath9k/debug.c | 122 ++++++---------------------------
>  drivers/net/wireless/ath/ath9k/pci.c   |   1 +
>  3 files changed, 24 insertions(+), 100 deletions(-)

This also didn't apply :(
