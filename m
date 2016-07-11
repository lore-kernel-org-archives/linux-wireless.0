Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:38876 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085AbcGKP7t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Jul 2016 11:59:49 -0400
Received: by mail-wm0-f49.google.com with SMTP id o80so57651528wme.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jul 2016 08:59:48 -0700 (PDT)
Date: Mon, 11 Jul 2016 16:59:43 +0100
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Colin King <colin.king@canonical.com>
Cc: Lauro Ramos Venancio <lauro.venancio@openbossa.org>,
	Aloisio Almeida Jr <aloisio.almeida@openbossa.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	"David S . Miller" <davem@davemloft.net>,
	Rolf Neugebauer <rolf.neugebauer@netronome.com>,
	Christophe Ricard <christophe.ricard@gmail.com>,
	Robert Dolca <robert.dolca@intel.com>,
	oss-drivers@netronome.com, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: Re: [oss-drivers] [PATCH][V2] nfp: check idx is -ENOSPC before
 using it is an index
Message-ID: <20160711165943.09c3c519@jkicinski-Precision-T1700> (sfid-20160711_175955_180443_6C4A9697)
In-Reply-To: <1468252460-15117-1-git-send-email-colin.king@canonical.com>
References: <1468252460-15117-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 11 Jul 2016 16:54:20 +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> idx can be returned as -ENOSPC, so we should check for this first
> before using it as an index into nn->vxlan_usecnt[] to avoid an
> out of bounds array offset read.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Thanks!
