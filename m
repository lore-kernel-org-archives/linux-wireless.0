Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56476 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752252AbaDYPod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:44:33 -0400
Message-ID: <1398439632.4152.14.camel@jlt4.sipsolutions.net> (sfid-20140425_174451_718437_6503D9A8)
Subject: Re: [PATCH 1/2 V3] mac80211: add option to generate CCMP IVs only
 for mgmt frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Marek Kwaczynski <marek.kwaczynski@tieto.com>
Cc: linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Date: Fri, 25 Apr 2014 17:27:12 +0200
In-Reply-To: <1397467642-23544-1-git-send-email-marek.kwaczynski@tieto.com> (sfid-20140414_112812_088705_2F071D07)
References: <1397467642-23544-1-git-send-email-marek.kwaczynski@tieto.com>
	 (sfid-20140414_112812_088705_2F071D07)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-14 at 11:27 +0200, Marek Kwaczynski wrote:
> Some chips can encrypt managment frames in HW, but
> require generated IV in the frame. Add a key flag
> that allows us to achieve this.

Applied.

johannes

