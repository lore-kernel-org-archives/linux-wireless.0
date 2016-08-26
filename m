Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:37111 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752758AbcHZKs7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Aug 2016 06:48:59 -0400
Received: by mail-it0-f51.google.com with SMTP id d65so18437231ith.0
        for <linux-wireless@vger.kernel.org>; Fri, 26 Aug 2016 03:48:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
References: <20160826102250.24174-1-rmanohar@qti.qualcomm.com>
From: Dave Taht <dave.taht@gmail.com>
Date: Fri, 26 Aug 2016 03:48:42 -0700
Message-ID: <CAA93jw7vHWROH9Ymq1UoOKA5kw+fDbCM=vJehs8J=QP2PVs_RA@mail.gmail.com> (sfid-20160826_124913_305753_49D4FF3C)
Subject: Re: [PATCH v3] ath10k: implement NAPI support
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Cc: ath10k <ath10k@lists.infradead.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm always rather big on people testing latency under load, and napi
tends to add some.
