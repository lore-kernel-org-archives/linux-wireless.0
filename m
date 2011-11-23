Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55575 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab1KWO3S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Nov 2011 09:29:18 -0500
Received: by vcbfk14 with SMTP id fk14so358373vcb.19
        for <linux-wireless@vger.kernel.org>; Wed, 23 Nov 2011 06:29:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201111230330.11103.tlnd@online.de>
References: <201111230330.11103.tlnd@online.de>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Wed, 23 Nov 2011 06:28:57 -0800
Message-ID: <CAB=NE6U6ru-xns8M+YUccqxw0FwE-sWtZnFkPUud3jHdAcDxsw@mail.gmail.com> (sfid-20111123_152921_163502_2D79E446)
Subject: Re: [PATCH] cfg80211: Fix changing regulatory from userspace
To: Timo Lindhorst <tlnd@online.de>
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 22, 2011 at 6:30 PM, Timo Lindhorst <tlnd@online.de> wrote:
> The commit de3584bd62d87b4c250129fbc46ca52c80330add -
> "cfg80211: fix regulatory NULL dereference" prevents the regulatory
> domain from being changed by user space. A wiphy is only present
> if the request comes from driver or is set by country IE, thus
> check only those cases.
>
> Signed-off-by: Timo Lindhorst <tlnd@online.de>

Yup but at this point I'd prefer we revert the original patch instead
given that the patch also had some other short comings. John is it too
late?

  Luis
