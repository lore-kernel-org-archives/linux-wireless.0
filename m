Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39558 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758685AbaJaUPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Oct 2014 16:15:10 -0400
Date: Fri, 31 Oct 2014 16:07:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, ath9k-devel@venema.h4ckr.net
Subject: Re: [PATCH 3/3] ath: ath9k: use debugfs_create_devm_seqfile() helper
 for seq_file entries
Message-ID: <20141031200726.GF3768@tuxdriver.com> (sfid-20141031_211556_050145_F98549DB)
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

Acked-by: John W. Linville <linville@tuxdriver.com>

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
