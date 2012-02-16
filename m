Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab2BPTyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 14:54:33 -0500
Received: by iacb35 with SMTP id b35so3305322iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 11:54:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329341872-12872-1-git-send-email-linville@tuxdriver.com>
References: <1329341872-12872-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 16 Feb 2012 11:54:12 -0800
Message-ID: <CAB=NE6V0VDxBq5MhDnzjQaYqjoXgaoRuvo9RjGw_vfQWw7RxeA@mail.gmail.com> (sfid-20120216_205443_139483_6E1FA0F5)
Subject: Re: [PATCH] compat-wireless: remove olpc_ec_wakeup_* calls for
 pre-3.1 kernels
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 15, 2012 at 1:37 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This section of the libertas driver calls functions that simply don't
> exist before the release of 3.1.  This code in question was an addition,
> not a change from any existing code.  It is safe to simply remove it for
> older kernels.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Applied and pushed, thanks!

  Luis
