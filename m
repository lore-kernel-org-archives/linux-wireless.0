Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:58530 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2JaPOl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 31 Oct 2012 11:14:41 -0400
Received: by mail-la0-f46.google.com with SMTP id h6so1135273lag.19
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2012 08:14:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1578864.KppKrIJQWb@lx-vladimir>
References: <1351511906-19989-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <1351511906-19989-2-git-send-email-qca_vkondrat@qca.qualcomm.com>
 <20121031012225.GY3354@lenteja.do-not-panic.com> <1578864.KppKrIJQWb@lx-vladimir>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 31 Oct 2012 08:14:19 -0700
Message-ID: <CAB=NE6WRG9yYV=NLORnEEHSkgfjBSdZr_pycLCmCN2cRUFvQKw@mail.gmail.com> (sfid-20121031_161444_807348_080DC7F5)
Subject: Re: [PATCH v2 1/2] wireless: Driver for 60GHz card wil6210
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 31, 2012 at 5:57 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> By the way, Atheros driver carl9170 uses MODULE_VERSION, should we consider
> killing it?

Well its tied pretty heavily to the firmware which BTW is open and
GPLv2. Your driver does not need firmware (yet). Why exactly carl9170
would use MODULE_VERSION though... or need it.. is perhaps Christian
can clarify on. Christian any reason to have MODULE_VERSION(),
anything that provide to userspace that cannot be obtained by the
kernel release it came from instead?

  Luis
