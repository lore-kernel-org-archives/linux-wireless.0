Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f170.google.com ([209.85.215.170]:37463 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbaCGRbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 12:31:38 -0500
Received: by mail-ea0-f170.google.com with SMTP id g15so2439235eak.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Mar 2014 09:31:38 -0800 (PST)
Message-ID: <1394213496.25640.4.camel@umadbro> (sfid-20140307_183142_344256_2748CFA7)
Subject: Re: [RFC PATCH 6/8] nl80211: Support for 5/10 MHz channels when
 reporting BW restrictions
From: Rostislav Lisovy <lisovy@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 18:31:36 +0100
In-Reply-To: <1394202590.4653.8.camel@jlt4.sipsolutions.net>
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-7-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143812_856469_1F424A6E) <1394202590.4653.8.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 15:29 +0100, Johannes Berg wrote:
> This is the part of the code that I was referring to before, you
> should
> skip these channels if (!large) to not break older tools with too much
> data.

The whole channel (not only these attributes) should be excluded if the
'split wiphy info' is not supported? I thought that reporting these
attributes only 'if (large)' is a safe solution (except the userspace
will be lacking some information).

Thanks;
Rostislav

