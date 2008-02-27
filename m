Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.231]:62394 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbYB0Dzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 22:55:32 -0500
Received: by wx-out-0506.google.com with SMTP id h31so2553279wxd.4
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 19:55:31 -0800 (PST)
Message-ID: <43e72e890802261955h17bf5fcekc51d5a5b885373b1@mail.gmail.com> (sfid-20080227_035535_026557_36652CB5)
Date: Tue, 26 Feb 2008 22:55:30 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: Re: [PATCH 2/8] ath5k: Add RF2413 initial settings
In-Reply-To: <20080224041509.GA4426@makis.domain.invalid>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224041509.GA4426@makis.domain.invalid>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Feb 23, 2008 at 11:15 PM, Nick Kossifidis <mick@madwifi.org> wrote:
> * Add initial settings for RF2413
>
>  Changes-licensed-under: ISC
>  Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

Please run through checkpatch, this patch fails its check at several places.

  Luis
