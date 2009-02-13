Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.169]:42431 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760AbZBMKam (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Feb 2009 05:30:42 -0500
Received: by wf-out-1314.google.com with SMTP id 28so1358512wfa.4
        for <linux-wireless@vger.kernel.org>; Fri, 13 Feb 2009 02:30:41 -0800 (PST)
MIME-Version: 1.0
Date: Fri, 13 Feb 2009 02:30:41 -0800
Message-ID: <569c3a50902130230w2f141b19vd3f7ce361545251d@mail.gmail.com> (sfid-20090213_113047_068498_75998E09)
Subject: iwlwifi: which PHY features, SM or STBC, it uses?
From: "An (Jack) Chan" <jackachan@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

Does anybody know which PHY features, SM (spatial multiplexing) or
STBC (space time block code), iwlwifi (on Intel 5300) implements?

In the 802.11n standard, both operation modes, SM and STBC, are
supported in HT STA. In commercial products, there is a trend to use
STBC over SM. But, I am not sure which mode iwlwifi implements, or it
supports both. Does anybody know the details.

Thanks,

Jack
