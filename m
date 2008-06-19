Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.237]:40839 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbYFSVbF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 17:31:05 -0400
Received: by rv-out-0506.google.com with SMTP id k40so5361115rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 14:31:05 -0700 (PDT)
Message-ID: <69e28c910806191431r96f2ab8vefac8321d26d846e@mail.gmail.com> (sfid-20080619_233114_458032_31335596)
Date: Thu, 19 Jun 2008 23:31:04 +0200
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomas.winkler@intel.com>
Subject: Re: [PATCH 1/1] mac80211: fix tx fragmenation
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <1213909810-23170-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1213909810-23170-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 19, 2008 at 11:10 PM, Tomas Winkler <tomas.winkler@intel.com> wrote:
> +               memcpy(frag->cb, first->cb, sizef(frag->cb));

Shouldn't that be sizeof(frag->cb)? "Sizef" doesn't even compile.

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
