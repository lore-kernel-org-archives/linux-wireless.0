Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.30]:61666 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbYLVSsX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:48:23 -0500
Received: by yx-out-2324.google.com with SMTP id 8so750725yxm.1
        for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:48:22 -0800 (PST)
Message-ID: <43e72e890812221048w6862b8f9p2c46ebe080818625@mail.gmail.com> (sfid-20081222_194827_718890_CCE82814)
Date: Mon, 22 Dec 2008 10:48:21 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: pat-lkml <pat-lkml@erley.org>
Subject: Re: [patch] Allow CRDA to use new libnl
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <494AE20D.2010709@erley.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <494AE20D.2010709@erley.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 3:51 PM, pat-lkml <pat-lkml@erley.org> wrote:
> This patch updates CRDA to use the new libnl-2 interface, and adds
> backwards compatability with libnl-1.  It follows the same pattern that
> the patch included into iw uses.
>
> Signed-off-by: Pat Erley <pat-lkml@erley.org>

Thanks, applied.

  Luis
