Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59072 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752902Ab2BPTy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 14:54:58 -0500
Received: by mail-iy0-f174.google.com with SMTP id b35so3305322iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 16 Feb 2012 11:54:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1329341785-12811-1-git-send-email-linville@tuxdriver.com>
References: <1329341785-12811-1-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 16 Feb 2012 11:54:38 -0800
Message-ID: <CAB=NE6Vxh8kobNBP6Xsx_Rt31gwqKbC=cu6ovjaJCUYycQejLg@mail.gmail.com> (sfid-20120216_205501_867119_739DE6EF)
Subject: Re: [PATCH] compat: add dummy lockdep_rtnl_is_held implementation
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 15, 2012 at 1:36 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> Obviously, this is wrong.  But the base kernel will have rtnl_mutex
> declared static, with no way to access it.  I think this is the best
> we can do...
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>
> ---

Applied and pushed, thanks!

  Luis
