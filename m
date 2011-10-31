Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4200 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1JaV24 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Oct 2011 17:28:56 -0400
Message-ID: <4EAF1310.6030006@broadcom.com> (sfid-20111031_222859_975605_861EA696)
Date: Mon, 31 Oct 2011 14:28:48 -0700
From: "Franky Lin" <frankyl@broadcom.com>
MIME-Version: 1.0
To: "Daniel Wolstenholme" <daniel@wolstenholme.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211 events
References: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com>
In-Reply-To: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/27/2011 03:27 PM, Daniel Wolstenholme wrote:
> Hi all,
>
> I'm working with the Broadcom brcmfmac driver, and I'm attempting to improve
> event reporting, but I'm finding there's not that much documentation on
> wireless events.  One big problem I'm having is that I'm using the cfg80211
> interface, but when I run "iw event -t -f", I don't see the events showing
> up.  Another question I have is: is there a way to send events with
> arbitrary strings from the driver through to userspace?
>
> Any pointers would be greatly appreciated.
>
> Dan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Dan,

Just curious, on what kind of hardware platform are you using brcmfmac?

Thanks,
Franky

