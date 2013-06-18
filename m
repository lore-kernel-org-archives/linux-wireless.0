Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39060 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab3FRN6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 09:58:49 -0400
Message-ID: <1371563915.8318.16.camel@jlt4.sipsolutions.net> (sfid-20130618_155852_968686_912727AE)
Subject: Re: [PATCH v3] mac80211: update mesh beacon on workqueue
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: open80211s <devel@lists.open80211s.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Tue, 18 Jun 2013 15:58:35 +0200
In-Reply-To: <1371164081-5516-1-git-send-email-thomas@cozybit.com> (sfid-20130614_005714_346655_FC3656B7)
References: <1371164081-5516-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130614_005714_346655_FC3656B7)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-06-13 at 15:54 -0700, Thomas Pedersen wrote:


>   * @MESH_WORK_ROOT: the mesh root station needs to send a frame
>   * @MESH_WORK_DRIFT_ADJUST: time to compensate for clock drift relative to other
> + * @MESH_WORK_MBSS_CHANGED: rebuild beacon and notify driver of BSS changes
>   * mesh nodes

That seems to have gone wrong :)

I fixed it and applied this.

johannes

