Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.179]:41757 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbYDWLCf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Apr 2008 07:02:35 -0400
Received: by wa-out-1112.google.com with SMTP id m16so4548563waf.23
        for <linux-wireless@vger.kernel.org>; Wed, 23 Apr 2008 04:02:34 -0700 (PDT)
Message-ID: <1ba2fa240804230402q3d2cb68en61051431f946c903@mail.gmail.com> (sfid-20080423_130314_335187_D2B7C5E0)
Date: Wed, 23 Apr 2008 14:02:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: [PATCH 1/1] iwlwifi: Fix built-in compilation of iwlcore
Cc: torvalds@linux-foundation.org, linville@tuxdriver.com,
	reinette.chatre@intel.com, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <20080423.040019.239111304.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1208948327-23894-1-git-send-email-tomas.winkler@intel.com>
	 <20080423.040019.239111304.davem@davemloft.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 23, 2008 at 2:00 PM, David Miller <davem@davemloft.net> wrote:
> From: Tomas Winkler <tomas.winkler@intel.com>
>  Date: Wed, 23 Apr 2008 13:58:47 +0300
>
>
>  > This patch fixes problem in Makefile that prevented
>  > built-in compilation of iwlcore
>  >
>  > Commit that caused this problem: eadd3c4b
>  >
>  > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>  > Signed-off-by: Yi Zhu <yi.zhu@intel.com>
>
>  I already applied the corrected version of your patch,
>  no need to resend this.  See my reply to your first
>  posting.
>
>
Thanks
Sorry for the mess
Tomas
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
