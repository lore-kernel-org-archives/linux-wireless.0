Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:34991 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932882Ab2JYGA3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Oct 2012 02:00:29 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so1780838iea.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 23:00:29 -0700 (PDT)
Message-ID: <5088D579.9000703@lwfinger.net> (sfid-20121025_080042_789249_AF728C2E)
Date: Thu, 25 Oct 2012 01:00:25 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Sujith Manoharan <c_manoha@qti.qualcomm.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	John W Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Regression in 3.7-rc2 for b43 and b43legacy
References: <50889F60.5090406@lwfinger.net> <20616.41414.398817.807498@gargle.gargle.HOWL>
In-Reply-To: <20616.41414.398817.807498@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/24/2012 09:19 PM, Sujith Manoharan wrote:
> Larry Finger wrote:
>
> This has been fixed:
> https://patchwork.kernel.org/patch/1625871/

That patch did the trick.

Thanks,

Larry


