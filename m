Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:35709 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532AbZKSVaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 16:30:30 -0500
Date: Thu, 19 Nov 2009 16:25:34 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Benoit Papillault <benoit.papillault@free.fr>
Cc: lrodriguez@atheros.com, jmalinen@atheros.com,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH] ath9k: This patch fix RX unpadding for any received
	frame.
Message-ID: <20091119212533.GF4960@tuxdriver.com>
References: <1258665566-4212-1-git-send-email-benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1258665566-4212-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 19, 2009 at 10:19:26PM +0100, Benoit Papillault wrote:
> From: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>
> 
> It has been tested with a 802.11 frame generator and by checking the FCS field
> of each received frame with the value reported by the Atheros hardware. This
> patch is useful if you are trying to analyze non standard 802.11 frame going
> over the air.
> 
> Signed-off-by: Benoit PAPILLAULT <benoit@benoit-laptop.(none)>

Are you sure this is this the email address you want?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
