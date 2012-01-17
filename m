Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59638 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab2AQA54 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 19:57:56 -0500
Received: by wgbdq11 with SMTP id dq11so1274154wgb.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 16:57:55 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgVL-tmY8e2hk43hQQot6YwvEWcQYwoSHLtQGj4JR+Nk3w@mail.gmail.com>
References: <86wr8rfbpf.fsf@sumi.keithp.com> <CA+55aFwdHKhLXF+Utbk0A2jcshSeQmQ91YxBzvqSa3wXCKh8BA@mail.gmail.com>
 <CAGRGNgVL-tmY8e2hk43hQQot6YwvEWcQYwoSHLtQGj4JR+Nk3w@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 16 Jan 2012 16:57:34 -0800
Message-ID: <CA+55aFz6qAY+q+Fes4gZdit1V_XQO7hcqp+V=ytuY=XYq2Tu8Q@mail.gmail.com> (sfid-20120117_015816_254099_047D36B4)
Subject: Re: MBA resume wedge due to wireless fixed yet?
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Keith Packard <keithp@keithp.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	David Miller <davem@davemloft.net>,
	=?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 16, 2012 at 4:37 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
> Hi all,
>
> I have a stupid question:
>
> On Tue, Jan 17, 2012 at 10:56, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> I have patches, but haven't committed them because I was kind of
>> expecting them to go through the wireless tree.
>
> Then why were these patches never posted to linux-wireless?

They were posted to at least netdev, they were cc'd to the top-level
maintainers (both David and Linville), and the maintainers of the
driver itself.

wireless seems to have been overlooked, but they were certainly not
hidden or kept private. I personally don't tend to remember the
wireless list, because everything I get comes through David and is
just "networking".

                      Linus
