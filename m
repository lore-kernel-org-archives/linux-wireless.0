Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f52.google.com ([209.85.161.52]:57682 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GUSZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 14:25:02 -0400
Received: by fxd18 with SMTP id 18so3909333fxd.11
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jul 2011 11:25:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1311266334.3059.11.camel@dcbw.foobar.com>
References: <20110720165403.52B629D401C@zog.reactivated.net>
	<87hb6gu8k5.fsf@purkki.adurom.net>
	<1311266334.3059.11.camel@dcbw.foobar.com>
Date: Thu, 21 Jul 2011 19:25:01 +0100
Message-ID: <CAGq3pz54mTJdsvjTW7PtkwTAEFFK7Y-j1DRbX=AiF7MBzZswuA@mail.gmail.com> (sfid-20110721_202507_947866_C2ECCD86)
Subject: Re: [PATCH v2 3/3] libertas: reimplement mesh channel selection
From: Daniel Drake <dsd@laptop.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Kalle Valo <kvalo@adurom.com>, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com, libertas-dev@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 July 2011 17:38, Dan Williams <dcbw@redhat.com> wrote:
> Mesh on OLPC/usb8388 was a pre-802.11s mesh protocol specific to OLPC
> implementations.  It's unlikely it would map directly to the standard
> mesh layer in mac80211/nl80211, plus it's all fullmac handled by the
> firmware.  So unless we want to look into creating one-off commands for
> the OLPC mesh bits for nl80211, we probably just want to keep the wext
> bits for this until we remove wext completely in the next few years.

I've got it working creating a 2nd interface off the same wiphy, it
seems to be working and avoids wext. It was simpler than I expected.
I'll submit it later and we'll see if people like it.

Thanks,
Daniel
