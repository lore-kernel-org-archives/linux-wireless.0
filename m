Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.177]:64972 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487AbYAJUVO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jan 2008 15:21:14 -0500
Received: by py-out-1112.google.com with SMTP id u52so1213237pyb.10
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2008 12:21:12 -0800 (PST)
Message-ID: <43e72e890801101221v3985bc80ic24f545c5c64d36e@mail.gmail.com> (sfid-20080110_202117_820995_9B0B4865)
Date: Thu, 10 Jan 2008 15:21:10 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Bruno Randolf" <bruno@thinktube.com>
Subject: Re: [PATCH 3/6] ath5k: comment out unused beacon functions and structures
Cc: ath5k-devel@lists.ath5k.org, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <1199870169-10476-4-git-send-email-bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1199870169-10476-1-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-2-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-3-git-send-email-bruno@thinktube.com>
	 <1199870169-10476-4-git-send-email-bruno@thinktube.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Jan 9, 2008 4:16 AM, Bruno Randolf <bruno@thinktube.com> wrote:
> use '#if 0' to comment out unused functions and structures wrt beacons. we
> might need that info later but right now they are useless and probably need to
> be rewritten.

Instead you should nuke this stuff and add it back when you need it.

  Luis
