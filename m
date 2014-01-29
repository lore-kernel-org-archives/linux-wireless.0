Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaA2NSK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jan 2014 08:18:10 -0500
Message-ID: <1391001487.4143.19.camel@jlt4.sipsolutions.net> (sfid-20140129_141814_335283_C37B442A)
Subject: Re: [PATCH v3 1/2] cfg80211: add helper reg_get_regdomain() function
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: linux-wireless@vger.kernel.org, mcgrof@do-not-panic.com,
	Janusz Dziedzic <janusz.dziedzi@tieto.com>
Date: Wed, 29 Jan 2014 14:18:07 +0100
In-Reply-To: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com> (sfid-20140125_112424_037754_55C995EF)
References: <1390645452-2495-1-git-send-email-janusz.dziedzic@tieto.com>
	 (sfid-20140125_112424_037754_55C995EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-01-25 at 11:24 +0100, Janusz Dziedzic wrote:
> Add helper function that will return regdomain.
> Follow the driver's regulatory domain, if present,
> unless a country IE has been processed or a user
> wants to help complaince further.

Applied, but I removed the 'reg' variable since it seemed useless in the
new function.

johannes

