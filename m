Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33246 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab2FFKYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 06:24:12 -0400
Message-ID: <1338978250.4513.55.camel@jlt3.sipsolutions.net> (sfid-20120606_122415_562989_6AD6FAE9)
Subject: Re: [PATCH 2/4] mac80211: implement the proactive PREQ generation
From: Johannes Berg <johannes@sipsolutions.net>
To: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Date: Wed, 06 Jun 2012 12:24:10 +0200
In-Reply-To: <1338978039-4269-3-git-send-email-yeohchunyeow@gmail.com> (sfid-20120606_122107_848877_726A8E55)
References: <1338978039-4269-1-git-send-email-yeohchunyeow@gmail.com>
	 <1338978039-4269-3-git-send-email-yeohchunyeow@gmail.com>
	 (sfid-20120606_122107_848877_726A8E55)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-06-06 at 18:20 +0800, Chun-Yeow Yeoh wrote:

> +enum mesh_hwmp_rootmode {
> +	noRoot = 0,
> +	notavailable,
> +	proactivePREQnoPREP,
> +	proactivePREQwithPREP,
> +	rann
> +};

Those are some ugly names .. I think they should have a prefix and be
less camel-case

johannes

