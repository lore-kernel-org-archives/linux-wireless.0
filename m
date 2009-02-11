Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from madara.hpl.hp.com ([192.6.19.124]:51670 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758630AbZBKV3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Feb 2009 16:29:47 -0500
Date: Wed, 11 Feb 2009 13:15:51 -0800
From: Jean Tourrilhes <jt@hpl.hp.com>
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] wavelan: Test arraysize before an element of the array.
Message-ID: <20090211211551.GA17560@bougret.hpl.hp.com> (sfid-20090211_223004_157799_F160B5E1)
Reply-To: jt@hpl.hp.com
References: <49933A53.8050901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <49933A53.8050901@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 11, 2009 at 09:51:31PM +0100, Roel Kluin wrote:
> Test arraysize before an element of the array.
>=20

	Hmm... I don=B4t see the point. The array can not be empty, as
it=B4s a constant, and would make the driver totally useless. But feel
free to send it to push it through John Linville if you feel strongly
about it...

> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>

	Regards,

	Jean
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
