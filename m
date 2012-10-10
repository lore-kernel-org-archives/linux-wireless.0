Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41748 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab2JJWvt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Oct 2012 18:51:49 -0400
Received: by mail-ee0-f46.google.com with SMTP id b15so738555eek.19
        for <linux-wireless@vger.kernel.org>; Wed, 10 Oct 2012 15:51:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1349893385-23102-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1349893385-23102-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 11 Oct 2012 09:51:28 +1100
Message-ID: <CAGRGNgUidXkunAuXXoM54-d48HcnAvYBiHrmZL5_7jt=ytF5AQ@mail.gmail.com> (sfid-20121011_005153_334729_C98430FE)
Subject: Re: [PATCH v0 0/2] driver for 60g Wilocity chip wil6210
To: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
Cc: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Vladimir,

On Thu, Oct 11, 2012 at 5:23 AM, Vladimir Kondratiev
<qca_vkondrat@qca.qualcomm.com> wrote:
> Hi,
>
> Here goes driver for the "wil6210" chip by Wilocity.
>
> This is development snapshot, only basic functionality is working.
> Chip firmware is also in active development, it is likely that
> firmware API will change.
>
> Code have style warnings like #ifdef's - some code is not integrated,
> there are places where one can play with different options;
> these #ifdef's will go away later.
>
> But, there is enough content to start with. In the lab I have stable
> link with 1.2 Gbps throughput, as measured by iperf.

Whilst I'm sure that this driver will end up being kernel quality
code, as this is an initial development snapshot, have you considered
putting it in "staging" until it's mostly feature complete?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
