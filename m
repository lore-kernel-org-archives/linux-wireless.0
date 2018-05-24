Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:39840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964903AbeEXXjs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 May 2018 19:39:48 -0400
Date: Thu, 24 May 2018 19:39:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Alexei Starovoitov <ast@kernel.org>, davem@davemloft.net,
        daniel@iogearbox.net, torvalds@linux-foundation.org,
        peterz@infradead.org, mathieu.desnoyers@efficios.com,
        netdev@vger.kernel.org, kernel-team@fb.com,
        linux-api@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [v8, bpf-next, 4/9] net/wireless/iwlwifi: fix
 iwlwifi_dev_ucode_error tracepoint
Message-ID: <20180524193944.49b2b1e7@gandalf.local.home> (sfid-20180525_014329_070529_59E88AC1)
In-Reply-To: <20180524232837.24jvdsdiohkpj7fs@ast-mbp>
References: <20180328190540.370956-5-ast@kernel.org>
        <1527073388.3759.21.camel@sipsolutions.net>
        <20180524232837.24jvdsdiohkpj7fs@ast-mbp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 24 May 2018 16:28:39 -0700
Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:

> Ohh. I didn't realize that networking wireless doesn't fall under netdev.
> I thought wireless folks are silent because they are embarrassed
> by a function with 17 arguments.

Please lets refrain from the demeaning comments.

I agree with your argument, but not the tone.

-- Steve
