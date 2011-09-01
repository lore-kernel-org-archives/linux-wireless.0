Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bsmtp4.bon.at ([195.3.86.186]:35964 "EHLO bsmtp.bon.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753665Ab1IAGYz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 02:24:55 -0400
References: <CAD2nsn2Bbxxy9ZYpBe_QEqCkGYYROHE+j7qASRq3OkKmWD5PMg@mail.gmail.com> <CAD2nsn1+5QWtzeG-3RHEJi8+oDthAfXYunHnDTLie84oJPOQuw@mail.gmail.com> <CAD2nsn1roVNB5+H1CYHVnerLN3pjGB5KmEX1mJZ4yJhHqFGOVA@mail.gmail.com> <20110830064137.GA4719@ecki> <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
In-Reply-To: <CAD2nsn2Reu+T=g6HwdQT5cdkD0C-06y7GJ_B2q-UzpRnshxAWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: ath9k: irq storm after suspend/resume
From: Clemens Buchacher <drizzd@aon.at>
Date: Thu, 01 Sep 2011 08:24:34 +0200
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: linux-wireless@vger.kernel.org, beta992@gmail.com
Message-ID: <14be9f3b-4c91-481d-9e52-f3119659fd59@email.android.com> (sfid-20110901_082502_657042_75BF4158)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mohammed Shafi <shafi.wireless@gmail.com> wrote:
>
>i am bit confused looking at bug comments. please correct me.
>the bug comments say that disabling/making the Network-Manager to
>sleep triggers the problem.
That is correct.
