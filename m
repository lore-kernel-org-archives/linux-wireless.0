Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:4414 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755004AbYBDUCa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Feb 2008 15:02:30 -0500
Date: Mon, 4 Feb 2008 14:50:24 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Denis Cheng <crquan@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/ath5k: renamed to ath5k_pci_driver to fix
	Section mismatch warnings
Message-ID: <20080204195024.GF3446@tuxdriver.com> (sfid-20080204_200235_839432_F2FF3121)
References: <1201920910-6649-1-git-send-email-crquan@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1201920910-6649-1-git-send-email-crquan@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 02, 2008 at 10:55:10AM +0800, Denis Cheng wrote:
> the struct pci_driver refered ath5k_pci_id_table which in __devinit section,
> the sparse tool suggest this renamed to "*driver", kills mismatch warnings.
> 
> Signed-off-by: Denis Cheng <crquan@gmail.com>

Sorry, I beat you to it on Friday... :-)

John
-- 
John W. Linville
linville@tuxdriver.com
