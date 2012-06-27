Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:49340 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026Ab2F0O6J convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Jun 2012 10:58:09 -0400
Received: by gglu4 with SMTP id u4so970244ggl.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Jun 2012 07:58:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340805979.11012.34.camel@jlt3.sipsolutions.net>
References: <1340805097.11012.24.camel@jlt3.sipsolutions.net>
	<1340805979.11012.34.camel@jlt3.sipsolutions.net>
Date: Wed, 27 Jun 2012 07:58:08 -0700
Message-ID: <CAMcMvsjmbM1NXtiHhcGeDkim6PuTJKqoXfkvU4xxWJaqEP3-qA@mail.gmail.com> (sfid-20120627_165814_211718_1E70B947)
Subject: Re: 3.4.x bug with channel type changes
From: Paul Stewart <pstew@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	manschwetus@googlemail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 27, 2012 at 7:06 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-06-27 at 15:51 +0200, Johannes Berg wrote:
>
>> Now, the reason I'm writing all this in an email and not a commit log is
>> that I don't know what the TX/RX channel type usage should be, or if
>> maybe it should be "if (queues_stopped) wake_queues()" or something like
>> that... Can you tell me what it should be?
>
> Something like this should help, of course, but maybe there are other
> issues in this area too?
>
> http://p.sipsolutions.net/3e89ee42463d6cc9.txt

This looks good to me, however, Rajkumar might be better at answering
the question of correctness since I was only involved as far as
changing the rate control, and didn't (intend to) change anything as
far as queues go.


>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
