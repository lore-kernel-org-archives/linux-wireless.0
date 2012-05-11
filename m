Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:61788 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759925Ab2EKQwd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 12:52:33 -0400
Received: by qcro28 with SMTP id o28so2147986qcr.19
        for <linux-wireless@vger.kernel.org>; Fri, 11 May 2012 09:52:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <1336665952-24363-4-git-send-email-johannes@sipsolutions.net>
References: <1336665952-24363-1-git-send-email-johannes@sipsolutions.net>
	<1336665952-24363-4-git-send-email-johannes@sipsolutions.net>
Date: Fri, 11 May 2012 18:52:31 +0200
Message-ID: <CA+icZUWNpJrqG5Gq9b5hM_cvFXsCHpzTZSYMmM-mUx5xKav4cw@mail.gmail.com> (sfid-20120511_185236_507248_12383292)
Subject: Re: [PATCH 3/4] iwlwifi: fix debug print in iwl_sta_calc_ht_flags
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 10, 2012 at 6:05 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
>
> We missed passing an argument to the
> debug print. Fix it.
>
> Signed-off-by: Meenakshi Venkataraman <meenakshi.venkataraman@intel.com>
> Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>

Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
