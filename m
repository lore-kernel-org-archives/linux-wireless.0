Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:49966 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759087Ab3E1N7h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 09:59:37 -0400
Received: by mail-bk0-f52.google.com with SMTP id mz10so4185369bkb.25
        for <linux-wireless@vger.kernel.org>; Tue, 28 May 2013 06:59:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369741393.8548.0.camel@jlt4.sipsolutions.net>
References: <CAKb7UvhBS6G=1Burf6MfekEnT5vhiy8BKijJ27Fpd=9yBDy9Ng@mail.gmail.com>
	<1369741393.8548.0.camel@jlt4.sipsolutions.net>
Date: Tue, 28 May 2013 09:59:35 -0400
Message-ID: <CAKb7Uvj5rr1CBxpas3kVKk7zdKDFs7+iVRVT7Q+Ob_mue6-_pQ@mail.gmail.com> (sfid-20130528_155941_055748_159CD4B1)
Subject: Re: iwlwifi dmar errors in 3.9.2
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 28, 2013 at 7:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-05-20 at 17:12 -0400, Ilia Mirkin wrote:
>> Hello,
>>
>> I recently upgraded to 3.9.2 from 3.7.10, and have begun to see some
>> DMAR errors in my log. Here are a bunch of them:
>> http://pastebin.com/wgq0JW0S
>
> Was there anything in the log _before_ this? Like the device already
> getting an error, or so?

Nothing that I felt was relevant, but you be the judge:
http://pastebin.com/s3rV3UK9

  -ilia
