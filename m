Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f170.google.com ([209.85.128.170]:54713 "EHLO
        mail-wr0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751414AbdJMUzN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Oct 2017 16:55:13 -0400
Received: by mail-wr0-f170.google.com with SMTP id o44so1852831wrf.11
        for <linux-wireless@vger.kernel.org>; Fri, 13 Oct 2017 13:55:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <59E124EB.6090602@candelatech.com>
References: <1507068826-14677-1-git-send-email-greearb@candelatech.com>
 <87a80vnrsb.fsf@kamboji.qca.qualcomm.com> <CAJ-Vmon0SszxH22Zb+O5RVQSommFFuc5XmG+at9=xbGagOb7PQ@mail.gmail.com>
 <59E124EB.6090602@candelatech.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Fri, 13 Oct 2017 13:55:11 -0700
Message-ID: <CAJ-Vmo=dK0BSwE99Bx+qE2b1qokg_MyXTvhZTFLPcSbRwFGOfA@mail.gmail.com> (sfid-20171013_225551_270301_2BBCD772)
Subject: Re: [PATCH v2] ath10k: Retry pci probe on failure.
To: Ben Greear <greearb@candelatech.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[snip]

* WMI setup stuff fails locally because of memory fragmentation when
you reload the driver. Heh. Sigh.
* I also see the PCI wakeup failures, so I'm going to go poke that
soon and see what I find.



-adrian
