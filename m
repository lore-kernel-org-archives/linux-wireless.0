Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:56502 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565AbaDYPpf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Apr 2014 11:45:35 -0400
Message-ID: <1398440716.4152.27.camel@jlt4.sipsolutions.net> (sfid-20140425_174552_632433_143E7BE9)
Subject: Re: [PATCH 3/7] mac80211: add new RC API to retrieve expected
 throughput
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Quartulli <antonio@meshcoding.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-wireless@vger.kernel.org,
	devel@lists.open80211s.org,
	Antonio Quartulli <antonio@open-mesh.com>
Date: Fri, 25 Apr 2014 17:45:16 +0200
In-Reply-To: <1397484205-20905-3-git-send-email-antonio@meshcoding.com>
References: <1397484205-20905-1-git-send-email-antonio@meshcoding.com>
	 <1397484205-20905-3-git-send-email-antonio@meshcoding.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-04-14 at 16:03 +0200, Antonio Quartulli wrote:
> From: Antonio Quartulli <antonio@open-mesh.com>
> 
> In order to make mac80211 export the expected throughput,
> a new API which extracts such information from any mac80211
> SW RC algorithm is needed.
> Therefore add the new get_expected_throughput() member
> to the rate_control_ops structure.
> 
> The exported value is expressed in Mbps/100. Such unit has
> been chosen because it is the highest precision that
> MinstrelHT can return.

Same as in patch 2 - and realistically 2/3/4 could just be squashed.

johannes

