Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42279 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664Ab1KQXbn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 18:31:43 -0500
Received: by fagn18 with SMTP id n18so3670904fag.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 15:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321568442-22758-4-git-send-email-linville@tuxdriver.com>
References: <1321568442-22758-1-git-send-email-linville@tuxdriver.com> <1321568442-22758-4-git-send-email-linville@tuxdriver.com>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 17 Nov 2011 15:31:21 -0800
Message-ID: <CAB=NE6W36_R7DNYcqr1_MX=arA9JDU9Z26+S0kzZFi9J_bApTg@mail.gmail.com> (sfid-20111118_003147_351155_9E101075)
Subject: Re: [PATCH v2 4/4] compat: support RHEL6 as a build target
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 2:20 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> This patch enables compatibility with RHEL6 as a build target, mostly
> with simple tricks similar to what was added for compatibility with
> Debian Squeeze.
>
> Signed-off-by: John W. Linville <linville@tuxdriver.com>

Thanks for the very sexy respin! I've applied all of them on both
compat-wireless.git and compat.git.

  Luis
