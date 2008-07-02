Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:60831 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757502AbYGBBIu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 21:08:50 -0400
Subject: Re: [PATCH 29/33] iwlwifi: drop skb silently for Tx request in
	monitor mode
From: Zhu Yi <yi.zhu@intel.com>
To: Stefanik =?ISO-8859-1?Q?G=E1bor?= <netrolller.3d@gmail.com>
Cc: Michael Buesch <mb@bu3sch.de>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
In-Reply-To: <69e28c910806300328v34c0d1efk55792256c49c39f9@mail.gmail.com>
References: <1214817813-17639-1-git-send-email-yi.zhu@intel.com>
	 <1214817813-17639-30-git-send-email-yi.zhu@intel.com>
	 <69e28c910806300322i5ac6e123h23ed5c0419d087c1@mail.gmail.com>
	 <200806301226.50085.mb@bu3sch.de>
	 <69e28c910806300328v34c0d1efk55792256c49c39f9@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Date: Wed, 02 Jul 2008 09:07:16 +0800
Message-Id: <1214960836.14590.432.camel@debian.sh.intel.com> (sfid-20080702_030854_942815_3EA1890E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-30 at 12:28 +0200, Stefanik G=A8=A2bor wrote:
> There is another patch in this same patchset, which completely remove=
s
> the anti-injection code from 3945, so this actually causes a merge
> conflict. That's why I NACKed.

No, if you apply the patches in order.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
