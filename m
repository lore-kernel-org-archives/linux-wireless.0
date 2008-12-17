Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:56021 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbYLQWmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2008 17:42:39 -0500
Received: by bwz14 with SMTP id 14so536942bwz.13
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2008 14:42:37 -0800 (PST)
Message-ID: <1ba2fa240812171442i2a348e91paf3434d6b975642e@mail.gmail.com> (sfid-20081217_234243_754461_A75CCEB1)
Date: Thu, 18 Dec 2008 00:42:37 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Rami Rosen" <ramirose@gmail.com>
Subject: Re: [PATCH] [v3] iwlwifi: iwl-tx.c cleanup (remove unused parameters).
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, reinette.chatre@intel.com
In-Reply-To: <eb3ff54b0812171351r50de6af0td15bf29d7e863212@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <eb3ff54b0812152335p6f768aa4r7ad68b33e62bd20b@mail.gmail.com>
	 <20081217163908.GD12679@tuxdriver.com>
	 <eb3ff54b0812171351r50de6af0td15bf29d7e863212@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 17, 2008 at 11:51 PM, Rami Rosen <ramirose@gmail.com> wrote:
> This patch removes unused parameters in methods in iwl-tx.c:
> remove a parameter (is_unicast) from iwl_tx_cmd_build_basic()
> remove a parameter (sta_id) from iwl_tx_cmd_build_rate()
> remove a parameter (sta_id ) from iwl_tx_cmd_build_hwcrypto()

Unicast can go sta_id has to stay, we need it for merging 3945 back
Thanks
Tomas
