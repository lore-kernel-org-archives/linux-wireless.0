Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53265 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbbAGKXj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 05:23:39 -0500
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21677.2491.857663.473071@gargle.gargle.HOWL> (sfid-20150107_112343_992420_FAAD84F0)
Date: Wed, 7 Jan 2015 15:56:03 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: "ath10k\@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: Fix DMA burst size
In-Reply-To: <CA+BoTQ=Vt8BTzZcgxqq4eU+RKhMwNbGrZOOFGL9TcBA3KnrerQ@mail.gmail.com>
References: <1419834066-11802-1-git-send-email-sujith@msujith.org>
	<CA+BoTQ=Vt8BTzZcgxqq4eU+RKhMwNbGrZOOFGL9TcBA3KnrerQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> Since it's for cards/chips why do you enable it for 10.2 only? There's
> 10.1, main and tlv as well which could possibly benefit from this.

I've not tested it with any of the FW versions other than 10.2 and
am not sure if older FW support this properly. We could try it
with 10.1, I guess - but even that is in 'maintenance mode'
internally.

Sujith
