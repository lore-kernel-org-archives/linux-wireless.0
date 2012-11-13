Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42157 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329Ab2KMTyP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Nov 2012 14:54:15 -0500
Message-ID: <1352836486.9466.25.camel@jlt4.sipsolutions.net> (sfid-20121113_205417_430891_17B642C6)
Subject: Re: [PATCH v7 2/2] wireless: integrate wil6210 driver into build
 structure
From: Johannes Berg <johannes@sipsolutions.net>
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Tue, 13 Nov 2012 20:54:46 +0100
In-Reply-To: <1352809427-29682-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1352809427-29682-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
	 <1352809427-29682-3-git-send-email-qca_vkondrat@qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2012-11-13 at 14:23 +0200, Vladimir Kondratiev wrote:

> +config ATH_COMMON
> +	tristate

I think you should (in the changelog) explain this change and why you
touch all drivers.

johannes

