Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:39845 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351Ab1GSXPQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2011 19:15:16 -0400
Date: Wed, 20 Jul 2011 01:15:09 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Pavel Roskin <proski@gnu.org>, b43-dev@lists.infradead.org
Subject: Re: [PATCH 1/3] b43: replace DMA translation workarounds with just
 a one, commented
Message-ID: <20110720011509.504022f8@maggie> (sfid-20110720_011520_585472_0FD9A655)
In-Reply-To: <1311113542-2540-2-git-send-email-zajec5@gmail.com>
References: <1311113542-2540-1-git-send-email-zajec5@gmail.com>
	<1311113542-2540-2-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 20 Jul 2011 00:12:20 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:
> +		 * be fixed on ssb side, but requires testing with b43,
> +		 * b43legacy and b44. */

No it doesn't. b44 and b43legacy don't use 64bit DMA.
Just fix it in ssb, please.
