Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f16.google.com ([209.85.217.16]:56918 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755107AbYJPX1g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Oct 2008 19:27:36 -0400
Received: by gxk9 with SMTP id 9so434820gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 16 Oct 2008 16:27:35 -0700 (PDT)
Message-ID: <43e72e890810161627vaa0d8ebq1ca2d2428e3fffa8@mail.gmail.com> (sfid-20081017_012740_076116_4F061295)
Date: Thu, 16 Oct 2008 16:27:34 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Christian Lamparter" <chunkeey@web.de>
Subject: Re: [PATCH 3/3] p54: AP & Ad-hoc testing
Cc: linux-wireless@vger.kernel.org,
	"John W Linville" <linville@tuxdriver.com>,
	"Larry Finger" <Larry.Finger@lwfinger.net>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Pavel Roskin" <proski@gnu.org>
In-Reply-To: <200810170117.07236.chunkeey@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <200810170117.07236.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 16, 2008 at 4:17 PM, Christian Lamparter <chunkeey@web.de> wrote:
> With this patch one can finally test Ad-hoc & AP mode.
> The station unlocking should work now, so the card doesn't have
> to be rebooted anymore.
>
> Signed-off-by: Christian Lamparter <chunkeey@web.de>

Nice, BTW besides ad-hoc what other stuff does prism54 support that
p54 doesn't? Also have you had any reports of users not being able to
use p54 over prism54?

I ask because I'd like to rm -rf prism54, specially if no distribution
is carrying it around anymore and if it has no users. Other
considerations against removing it before was that p54 wasn't feature
paired with prism54. I am wondering if this is still the case.

  Luis
