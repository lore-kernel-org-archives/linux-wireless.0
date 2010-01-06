Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f194.google.com ([209.85.223.194]:61452 "EHLO
	mail-iw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755540Ab0AFW1r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2010 17:27:47 -0500
Received: by iwn32 with SMTP id 32so1920969iwn.33
        for <linux-wireless@vger.kernel.org>; Wed, 06 Jan 2010 14:27:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
References: <1262362872-10251-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Wed, 6 Jan 2010 14:27:27 -0800
Message-ID: <43e72e891001061427l70a6711dg6e96d93679ccc17e@mail.gmail.com>
Subject: Re: [PATCH 0/5] compat-wireless: Activate ssb and libertas, refresh
	script
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 1, 2010 at 8:21 AM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> The first two patches were already send some time ago, but not applied,
> the second patch was applied partly. Patch 3 adds an refresh option to
> admin-update.sh and it was used in patch 4. The last patch fixes some
> small problems in admin-update.sh

All applied. I really liked the quilt patch, thanks so much, I didn't
know quilt could do that, that's awesome. It will certainly help with
keeping compat-wireless up to date as that is the most frequent thing
we have to do.

  Luis
