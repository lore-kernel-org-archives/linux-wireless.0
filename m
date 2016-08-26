Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48216 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753378AbcHZLMI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 07:12:08 -0400
Message-ID: <1472209920.390.34.camel@sipsolutions.net> (sfid-20160826_131232_740913_B8167E86)
Subject: Re: [PATCH v3] ath10k: implement NAPI support
From: Johannes Berg <johannes@sipsolutions.net>
To: Dave Taht <dave.taht@gmail.com>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Date: Fri, 26 Aug 2016 13:12:00 +0200
In-Reply-To: <CAA93jw7vHWROH9Ymq1UoOKA5kw+fDbCM=vJehs8J=QP2PVs_RA@mail.gmail.com> (sfid-20160826_124913_305753_49D4FF3C)
References: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
         <CAA93jw7vHWROH9Ymq1UoOKA5kw+fDbCM=vJehs8J=QP2PVs_RA@mail.gmail.com>
         (sfid-20160826_124913_305753_49D4FF3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-26 at 03:48 -0700, Dave Taht wrote:
> I'm always rather big on people testing latency under load, and napi
> tends to add some.

That's a completely useless comment.

Obviously, everybody uses NAPI; it's necessary for system load and thus
performance, and lets drivers take advantage of TCP merging to reduce
ACKs, which is tremendously helpful (over wifi in particular.)

Please stop making such drive-by comments that focus only on the single
thing you find important above all; not all people can care only about
that single thing, and unconstructively reiterating it over and over
doesn't help.

Thanks,
johannes
