Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35355 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3HOQSN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Aug 2013 12:18:13 -0400
Message-ID: <1376583478.14084.15.camel@jlt4.sipsolutions.net> (sfid-20130815_181835_816805_BFECD62A)
Subject: Re: [PATCH] net: rfkill: Do not ignore errors from
 regulator_enable()
From: Johannes Berg <johannes@sipsolutions.net>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	"John W. Linville" <linville@tuxdriver.com>
Date: Thu, 15 Aug 2013 18:17:58 +0200
In-Reply-To: <1376518206-10710-1-git-send-email-luis.henriques@canonical.com>
References: <1376518206-10710-1-git-send-email-luis.henriques@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-08-14 at 23:10 +0100, Luis Henriques wrote:
> Function regulator_enable() may return an error that has to be checked.
> This patch changes function rfkill_regulator_set_block() so that it checks
> for the return code.  Also, rfkill_data->reg_enabled is set to 'true' only
> if there is no error.

Applied.

johannes

