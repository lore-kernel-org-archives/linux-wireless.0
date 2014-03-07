Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:41690 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbaCGO20 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Mar 2014 09:28:26 -0500
Message-ID: <1394202503.4653.5.camel@jlt4.sipsolutions.net> (sfid-20140307_152828_503625_DC41266A)
Subject: Re: [RFC PATCH 3/8] cfg80211: Add attributes describing channel
 bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: Rostislav Lisovy <lisovy@gmail.com>
Cc: linux-wireless@vger.kernel.org, Michal Sojka <sojkam1@fel.cvut.cz>,
	s.sander@nordsys.de, jan-niklas.meier@volkswagen.de
Date: Fri, 07 Mar 2014 15:28:23 +0100
In-Reply-To: <1394199475-5208-4-git-send-email-rostislav.lisovy@fel.cvut.cz> (sfid-20140307_143807_579989_A10F377C)
References: <1394199475-5208-1-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 <1394199475-5208-4-git-send-email-rostislav.lisovy@fel.cvut.cz>
	 (sfid-20140307_143807_579989_A10F377C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-03-07 at 14:37 +0100, Rostislav Lisovy wrote:
> Since channels with frequencies ranging from 5850 to 5925
> are used with 5/10 MHz channels according to IEEE 802.11p,
> we need a way how to keep the information about the forbidden
> bandwidths.

I see no reason to have this as a separate patch with the previous one.

johannes

