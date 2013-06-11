Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37498 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab3FKMZ7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 08:25:59 -0400
Message-ID: <1370953555.8356.33.camel@jlt4.sipsolutions.net> (sfid-20130611_142602_303032_153515E6)
Subject: Re: [PATCH v2] {nl,mac,cfg}80211: Allow user to configure basic
 rates for mesh
From: Johannes Berg <johannes@sipsolutions.net>
To: Ashok Nagarajan <ashok@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	devel@lists.open80211s.org, javier@cozybit.com
Date: Tue, 11 Jun 2013 14:25:55 +0200
In-Reply-To: <1370280816-9799-1-git-send-email-ashok@cozybit.com> (sfid-20130603_193352_408512_D7024E7A)
References: <1370280816-9799-1-git-send-email-ashok@cozybit.com>
	 (sfid-20130603_193352_408512_D7024E7A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 10:33 -0700, Ashok Nagarajan wrote:
> Currently mesh uses mandatory rates as the default basic rates. Allow basic
> rates to be configured during mesh join. Basic rates are applied only if
> channel is also provided with mesh join command.

Applied, I fixed some whitespace and made it remove rates specification
w/o channel specification. Please check.

johannes

