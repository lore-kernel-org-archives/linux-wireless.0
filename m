Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:37786 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbbFZTqZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Jun 2015 15:46:25 -0400
Received: by wicgi11 with SMTP id gi11so26399141wic.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Jun 2015 12:46:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a159a6cc0459b2fa089f0f222085aeb2@mail.gmail.com>
References: <CAEFj986kwfLXqPm+qN6pbB+_Pe3m2-9PLNZXf6+pH_fCeQqZ8A@mail.gmail.com>
	<CAEFj984fG7oidP_u2vnH6p+VigjX_NF29JOfFWeAara8GCaiCg@mail.gmail.com>
	<CAEFj986=3t=9B5d_2JP1Yo2fSOEvb7wgRfgMWdyw4DnutrGANQ@mail.gmail.com>
	<a159a6cc0459b2fa089f0f222085aeb2@mail.gmail.com>
Date: Sat, 27 Jun 2015 03:46:23 +0800
Message-ID: <CAEFj9877azQTokwHAgg2-rn8Y5j41+5dW3BVAJpJwhwx2u4NRA@mail.gmail.com> (sfid-20150626_214629_978033_887C6D33)
Subject: Re: [PATCH] mac80211: mesh - don't special case routing to transmitter
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Jesse Jones <jjones@cococorp.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> There are two test scenarios:
> 1) When creating the path to a ta where the direct hop is a bad path.
> Relatively easy to setup and demonstrate poor performance pre-patch.
> 2) Incorrect routing when the metric for an existing SN is changed without
> also updating the SN. Hard to demonstrate. We've certainly seen similar bugs
> with our own mesh protocols but that was with protocols explicitly designed
> with testing support. Best approach is probably via something like
> http://alloy.mit.edu/alloy/

If the direct hop is a bad path, could it be due the metric calculation.

Also, you may also add your vendor specific mesh protocol to open
source community.

---
Chun-Yeow
