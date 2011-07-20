Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35505 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508Ab1GTSKw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Jul 2011 14:10:52 -0400
To: Daniel Drake <dsd@laptop.org>
Cc: linville@tuxdriver.com, dcbw@redhat.com,
	linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org
Subject: Re: [PATCH v2 3/3] libertas: reimplement mesh channel selection
References: <20110720165403.52B629D401C@zog.reactivated.net>
From: Kalle Valo <kvalo@adurom.com>
Date: Wed, 20 Jul 2011 21:10:50 +0300
In-Reply-To: <20110720165403.52B629D401C@zog.reactivated.net> (Daniel Drake's message of "Wed\, 20 Jul 2011 17\:54\:03 +0100 \(BST\)")
Message-ID: <87hb6gu8k5.fsf@purkki.adurom.net> (sfid-20110720_201055_514173_1E766668)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Drake <dsd@laptop.org> writes:

> This reimplements code allowing for mesh channel selection according
> to how NetworkManager expects.

[...]

> +static const iw_handler mesh_iw_handler[] =
> +{
> +	IW_HANDLER(SIOCGIWNAME, (iw_handler) mesh_get_name),
> +	IW_HANDLER(SIOCGIWFREQ, (iw_handler) mesh_get_freq),
> +	IW_HANDLER(SIOCSIWFREQ, (iw_handler) mesh_set_freq),
> +};

We are trying to remove wext code, not add it. I'm surprised to see this.

-- 
Kalle Valo
