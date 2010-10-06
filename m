Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:65347 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932440Ab0JFPHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 11:07:13 -0400
Received: by qyk29 with SMTP id 29so3238274qyk.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 08:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTi=1-r8XZHn9nqbbh2N=7yrsKXZbgxHNcNg+qFxo@mail.gmail.com>
References: <AANLkTin9hFUE_RH0Zb4OuV2dU_kJs6_ap=VxEmT3e3F8@mail.gmail.com>
	<20101006132301.GA2472@tuxdriver.com>
	<AANLkTi=1-r8XZHn9nqbbh2N=7yrsKXZbgxHNcNg+qFxo@mail.gmail.com>
Date: Wed, 6 Oct 2010 11:07:12 -0400
Message-ID: <AANLkTi=buSXukPp4xeSdig6z3rvNs2G=v6s1Y794Q2JK@mail.gmail.com>
Subject: Re: Why were patches reverted on 2010-09-21? (carl9170 and others)
From: Christian Jaeger <chrjae@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks for your explantion.

My patches on top of the stable kernel don't build (they depend a
'cipher' member on ‘struct ieee80211_key_conf’, and I guess there may
be more). If I want to reach my goal of trying carl9170 with a stable
kernel, should I still proceed that route, i.e. finding the patches
that carl* depends on, or trying to change the carl* code to not
require them, or is there a better idea? I'd like to avoid running
wireless-testing as is if possible (for fear of stability and security
issues on this world-facing, supposedly stable router of mine).

Thanks,
Christian.
