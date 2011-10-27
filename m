Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:1026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755266Ab1J0XJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 19:09:24 -0400
Subject: Re: cfg80211 events
From: Dan Williams <dcbw@redhat.com>
To: Daniel Wolstenholme <daniel@wolstenholme.net>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Oct 2011 18:09:38 -0500
In-Reply-To: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com>
References: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1319756980.4490.6.camel@dcbw.foobar.com> (sfid-20111028_010926_967933_D78AFAE6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-10-27 at 15:27 -0700, Daniel Wolstenholme wrote:
> Hi all,
> 
> I'm working with the Broadcom brcmfmac driver, and I'm attempting to improve
> event reporting, but I'm finding there's not that much documentation on
> wireless events.  One big problem I'm having is that I'm using the cfg80211
> interface, but when I run "iw event -t -f", I don't see the events showing
> up.  Another question I have is: is there a way to send events with
> arbitrary strings from the driver through to userspace?

I'd be careful of that; we don't want a repeat of IWPRIV events, we'd
rather have stuff standardized.  Unless you're doing this for testing,
of course.

Dan

> Any pointers would be greatly appreciated.
> 
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


