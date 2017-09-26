Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f45.google.com ([209.85.218.45]:45166 "EHLO
        mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967343AbdIZPMC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Sep 2017 11:12:02 -0400
Received: by mail-oi0-f45.google.com with SMTP id z73so12363386oia.2
        for <linux-wireless@vger.kernel.org>; Tue, 26 Sep 2017 08:12:02 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1506438516.22427.21.camel@sipsolutions.net>
References: <384966f3a79915b4617d808c40e63072aa8b868d.1506438160.git.andreyknvl@google.com>
 <1506438516.22427.21.camel@sipsolutions.net>
From: Andrey Konovalov <andreyknvl@google.com>
Date: Tue, 26 Sep 2017 17:12:01 +0200
Message-ID: <CAAeHK+xJLC9SVk=jMptduD08uPU_mgEjyCv2zESAUWOPPAjBpw@mail.gmail.com> (sfid-20170926_171442_849707_D9C9CB0C)
Subject: Re: [PATCH] p54: don't unregister leds when they are inited
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>,
        Kostya Serebryany <kcc@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 26, 2017 at 5:08 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Subject should say *not* initialized?

Yes, sent v2.

>
> johannes
