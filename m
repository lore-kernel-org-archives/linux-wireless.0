Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qe0-f49.google.com ([209.85.128.49]:58312 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437Ab3HUTAo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Aug 2013 15:00:44 -0400
Received: by mail-qe0-f49.google.com with SMTP id k5so502647qej.22
        for <linux-wireless@vger.kernel.org>; Wed, 21 Aug 2013 12:00:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANMvdA-SDgbL7p0xbXfOoWpgjf9viVKYwErHd8K-VBGZotLA1A@mail.gmail.com>
References: <CANMvdA-SDgbL7p0xbXfOoWpgjf9viVKYwErHd8K-VBGZotLA1A@mail.gmail.com>
Date: Wed, 21 Aug 2013 21:00:43 +0200
Message-ID: <CANMvdA-JXnO-01h1CBhw8PZkVRwJn=7cqLfYA5dagFXoGQG0vg@mail.gmail.com> (sfid-20130821_210048_536027_9E07102E)
Subject: Re: Tunneable mesh channels
From: Francisco Cuesta <ndarkness@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

 I was wondering a question concerning to channel selection on mesh
networks, in my previous version of compat-wirelessI disabled some
channels, but now in the new version(2013-06-27) they're back again.
So I would like to ensure that whether the channel is listed by iw phy
phyo info that channel can be used by the kernel when setting up the
mesh node or not; since as far as I know, if it does not show up after
issuing the command then that channel for sure cannot be used at all.

 Am I mistaken?

 Thanks in advance,

 Regards!
