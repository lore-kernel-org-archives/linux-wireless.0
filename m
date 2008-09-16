Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.28]:16932 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753885AbYIPSme (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Sep 2008 14:42:34 -0400
Received: by yw-out-2324.google.com with SMTP id 9so844595ywe.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Sep 2008 11:42:33 -0700 (PDT)
Message-ID: <43e72e890809161142t7d16b042gb179e126db14df9@mail.gmail.com> (sfid-20080916_204237_352821_83C191D5)
Date: Tue, 16 Sep 2008 11:42:33 -0700
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [RFC V2] mac80211: re-enable aggregation on 2.6.27
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, ron.rindjunsky@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <1221550508-3338-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2008 at 12:35 AM, Tomas Winkler <tomas.winkler@intel.com> wrote:

> V2:
>  1. removed skbuff ->is_part_ampdu
>  2. fixed compilation warnings

Very nice indeed, I'll work on top of this one.

  Luis
