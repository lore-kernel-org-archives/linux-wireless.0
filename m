Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.235]:35426 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbZESCQS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 22:16:18 -0400
Received: by rv-out-0506.google.com with SMTP id f9so1734925rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 18 May 2009 19:16:20 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090519014352.19524.10495.stgit@mj.roinet.com>
References: <20090519014352.19524.10495.stgit@mj.roinet.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 18 May 2009 19:16:00 -0700
Message-ID: <43e72e890905181916g4dad9415k308776ad86da60fb@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: fix compile error with CONFIG_CFG80211_DEBUGFS
To: Pavel Roskin <proski@gnu.org>
Cc: linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 18, 2009 at 6:43 PM, Pavel Roskin <proski@gnu.org> wrote:
> If CONFIG_CFG80211_DEBUGFS is enabled and CONFIG_MAC80211_DEBUGFS is
> not, compilation fails in net/wireless/debugfs.c:
>
> net/wireless/debugfs.c: In function 'cfg80211_debugfs_drv_add':
> net/wireless/debugfs.c:117: error: 'struct cfg80211_registered_device'
> has no member named 'debugfs'
>
> The debugfs filed is needed if and only if CONFIG_CFG80211_DEBUGFS is
> enabled, so use that instead of CONFIG_MAC80211_DEBUGFS.
>
> Signed-off-by: Pavel Roskin <proski@gnu.org>

Sorry for the trouble and thanks...

  Luis
