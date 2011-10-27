Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39602 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755210Ab1J0W1K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Oct 2011 18:27:10 -0400
Received: by vws1 with SMTP id 1so2940218vws.19
        for <linux-wireless@vger.kernel.org>; Thu, 27 Oct 2011 15:27:09 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 27 Oct 2011 15:27:09 -0700
Message-ID: <CAB1eQC7cXz0GpGrX7d8_nL_8d8ZAgxSzXUxqDhR7PiSSJysOoQ@mail.gmail.com> (sfid-20111028_002722_792238_FE002A77)
Subject: cfg80211 events
From: Daniel Wolstenholme <daniel@wolstenholme.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I'm working with the Broadcom brcmfmac driver, and I'm attempting to improve
event reporting, but I'm finding there's not that much documentation on
wireless events.  One big problem I'm having is that I'm using the cfg80211
interface, but when I run "iw event -t -f", I don't see the events showing
up.  Another question I have is: is there a way to send events with
arbitrary strings from the driver through to userspace?

Any pointers would be greatly appreciated.

Dan
