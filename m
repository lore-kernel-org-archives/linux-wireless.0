Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab0HBNW1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:22:27 -0400
Subject: Re: [PATCH 1/3] mac80211: put rx handlers into seperate functions
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <201008021515.06013.chunkeey@googlemail.com>
References: <201008021515.06013.chunkeey@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Aug 2010 15:22:25 +0200
Message-ID: <1280755345.3923.13.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-08-02 at 15:15 +0200, Christian Lamparter wrote:
> Note: In order to keep diff from removing and re-adding code,
> I used forward declarations. So it should be easier to verify
> that I didn't change anything related to the reordering logic.

FWIW, I'd prefer you didn't do that but moved the code instead.

johannes


