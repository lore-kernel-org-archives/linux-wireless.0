Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58947 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751478Ab1BSJD4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Feb 2011 04:03:56 -0500
Received: by bwz15 with SMTP id 15so1432896bwz.19
        for <linux-wireless@vger.kernel.org>; Sat, 19 Feb 2011 01:03:55 -0800 (PST)
Date: Sat, 19 Feb 2011 12:03:49 +0300
From: Stanislav Fomichev <kernel@fomichev.me>
To: Greg KH <greg@kroah.com>
Cc: brudley@broadcom.com, gregkh@suse.de,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] brcm80211: remove multiple calls to wl_release_fw
Message-ID: <4d5f877a.1211cc0a.3680.ffffabbc@mx.google.com>
References: <20110212150033.GA1941@sdf-MacBook>
 <20110218205700.GC796@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20110218205700.GC796@kroah.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This doesn't apply on linux-next, what tree is it supposed to be for?
I suppose it was based on the Linus's tree (I didn't know that the
developing is going on on this list).

Anyway, pls drop this patch; the similar fixes should be done in one of
the Roland Vossen's patches.

-- 
	Stas
