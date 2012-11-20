Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53665 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600Ab2KTIqe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 03:46:34 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5702834obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 00:46:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGRGNgV=4Lyumy=ivykkEgY=EVRjWM4MWPvGh-uUmPdGyJUxJw@mail.gmail.com>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-4-git-send-email-eliad@wizery.com>
	<CAGRGNgV=4Lyumy=ivykkEgY=EVRjWM4MWPvGh-uUmPdGyJUxJw@mail.gmail.com>
Date: Tue, 20 Nov 2012 10:46:34 +0200
Message-ID: <CAB3XZEdKr+BwhoOH+z2H9Wwo_5cuwomxkwy-RRNUi_8WNRHUSA@mail.gmail.com> (sfid-20121120_094642_278782_B94888F4)
Subject: Re: [PATCH 03/15] wlcore: always use sta.hlid
From: Eliad Peller <eliad@wizery.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Julian,

On Tue, Nov 20, 2012 at 12:39 AM, Julian Calaby <julian.calaby@gmail.com> wrote:
> On Tue, Nov 20, 2012 at 3:39 AM, Eliad Peller <eliad@wizery.com> wrote:
>> since we no longer use dev role in the connection flow,
>> we should always use the hlid of the sta role.
>
> I don't really know the hardware, but this seems like something
> something that should be combined with the first patch.
>
Thanks.
Johannes had a similar comment regarding another patch.
i split the patches in order to make them easier to review, even if it
temporarily breaks the driver.
As agreed with Luca, i'll send the next version (which will hopefully
be the last one ;), after squashing such patches together.

Eliad.
